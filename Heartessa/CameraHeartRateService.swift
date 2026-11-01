import AVFoundation
import Combine

@MainActor
final class CameraHeartRateService: NSObject, ObservableObject {

    enum MeasurementState: Equatable {
        case idle
        case cameraOpen
        case detecting
        case measuring(bpm: Int)
        case complete(bpm: Int)
        case error(String)
    }

    @Published var state: MeasurementState = .idle
    @Published var fingerDetected = false
    @Published var progress: Double = 0          // 0…1 during .measuring

    // nonisolated(unsafe): AVFoundation types predate Sendable; we manage thread safety manually.
    nonisolated(unsafe) let session = AVCaptureSession()

    nonisolated(unsafe) private let sessionQueue = DispatchQueue(label: "com.heartessa.camera", qos: .userInteractive)
    nonisolated(unsafe) private let sampleQueue  = DispatchQueue(label: "com.heartessa.ppg",    qos: .userInteractive)
    nonisolated(unsafe) private let videoOutput  = AVCaptureVideoDataOutput()
    nonisolated(unsafe) private weak var captureDevice: AVCaptureDevice?

    // PPG signal buffer — accessed only from sampleQueue via captureOutput dispatch
    private var redSamples:    [Double] = []
    private let targetFrames = 900          // 30 s × 30 fps — matches Instant Heart Rate / Cardiio standard
    private let stableFrames = 12           // 0.4 s of stable signal — easier to hit
    private var warmupCount  = 0
    private var noFingerCount = 0
    private var isListening  = false

    // MARK: - Public API

    func requestCameraAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor [weak self] in
                    if granted { self?.startCamera() }
                    else { self?.state = .error("Camera access denied. Enable it in Settings.") }
                }
            }
        default:
            state = .error("Camera access is required. Enable it in Settings.")
        }
    }

    func beginMeasurement() {
        guard case .cameraOpen = state else { return }
        redSamples    = []
        warmupCount   = 0
        noFingerCount = 0
        isListening   = true
        state = .detecting
    }

    func stop() {
        isListening = false
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
            self?.disableTorch()
        }
        state         = .idle
        fingerDetected = false
        progress      = 0
        redSamples    = []
        warmupCount   = 0
        noFingerCount = 0
    }

    // MARK: - Camera setup

    private func startCamera() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .low

            guard
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let input  = try? AVCaptureDeviceInput(device: device)
            else {
                Task { @MainActor [weak self] in self?.state = .error("Camera unavailable on this device.") }
                return
            }
            self.captureDevice = device

            if self.session.canAddInput(input) { self.session.addInput(input) }

            self.videoOutput.videoSettings             = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            self.videoOutput.alwaysDiscardsLateVideoFrames = true
            self.videoOutput.setSampleBufferDelegate(self, queue: self.sampleQueue)
            if self.session.canAddOutput(self.videoOutput) { self.session.addOutput(self.videoOutput) }

            // Lock FPS only (torch requires session to be running first)
            do {
                try device.lockForConfiguration()
                let fps30 = CMTime(value: 1, timescale: 30)
                device.activeVideoMinFrameDuration = fps30
                device.activeVideoMaxFrameDuration = fps30
                device.unlockForConfiguration()
            } catch {}

            self.session.commitConfiguration()
            self.session.startRunning()

            Task { @MainActor [weak self] in self?.state = .cameraOpen }
        }
    }

    func enableTorch() {
        sessionQueue.async { [weak self] in
            guard let device = self?.captureDevice,
                  device.hasTorch, device.isTorchAvailable else { return }
            try? device.lockForConfiguration()
            device.torchMode = .on
            device.unlockForConfiguration()
        }
    }

    nonisolated private func disableTorch() {
        guard let device = captureDevice, device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = .off
        device.unlockForConfiguration()
    }

    // MARK: - Frame processing (called on @MainActor via captureOutput dispatch)

    private func process(avgRed: Double) {
        let fingerPresent = avgRed > 0.65
        fingerDetected = fingerPresent

        guard isListening else { return }

        switch state {
        case .detecting:
            if fingerPresent {
                warmupCount   += 1
                noFingerCount  = 0
                if warmupCount >= stableFrames {
                    redSamples = []
                    state = .measuring(bpm: 0)
                }
            } else {
                noFingerCount += 1
                if noFingerCount > 5 { warmupCount = 0 } // allow brief gaps
            }

        case .measuring:
            // Use a lower removal threshold during recording — PPG signal oscillates
            // naturally so avgRed dips; only reset if finger is clearly gone.
            let fingerGone = avgRed < 0.40
            if fingerGone {
                noFingerCount += 1
                if noFingerCount > 60 {   // 2 s of truly missing finger
                    warmupCount   = 0
                    noFingerCount = 0
                    redSamples    = []
                    state = .detecting
                    return
                }
            } else {
                noFingerCount = 0
            }

            redSamples.append(avgRed)

            let prog = min(Double(redSamples.count) / Double(targetFrames), 1.0)
            let bpm  = redSamples.count >= 90 ? computeBPM(redSamples) : 0
            progress = prog
            state    = .measuring(bpm: bpm)

            if redSamples.count >= targetFrames {
                let finalBPM = computeBPM(redSamples)
                state = .complete(bpm: finalBPM)
            }

        default:
            break
        }
    }

    // MARK: - BPM algorithm (pure, nonisolated — safe to call from anywhere)

    nonisolated private func averageRed(in pixelBuffer: CVPixelBuffer) -> Double {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        let w   = CVPixelBufferGetWidth(pixelBuffer)
        let h   = CVPixelBufferGetHeight(pixelBuffer)
        guard let base = CVPixelBufferGetBaseAddress(pixelBuffer) else { return 0 }
        let bpr = CVPixelBufferGetBytesPerRow(pixelBuffer)

        let side = max(20, min(w, h) / 5)
        let x0 = (w - side) / 2
        let y0 = (h - side) / 2
        var total: Double = 0
        var count = 0

        for y in stride(from: y0, to: y0 + side, by: 2) {
            let row = base.advanced(by: y * bpr).assumingMemoryBound(to: UInt8.self)
            for x in stride(from: x0, to: x0 + side, by: 2) {
                total += Double(row[x * 4 + 2])   // BGRA → R at byte index 2
                count += 1
            }
        }
        return count > 0 ? total / (Double(count) * 255.0) : 0
    }

    nonisolated private func computeBPM(_ samples: [Double]) -> Int {
        guard samples.count > 30 else { return 0 }

        let mean = samples.reduce(0, +) / Double(samples.count)
        let sig  = samples.map { $0 - mean }

        let window  = 8
        let noise   = 0.003
        let minDist = 9     // 200 BPM → 0.3 s → 9 frames @ 30fps

        var peaks: [Int] = []
        for i in window..<(sig.count - window) {
            let v = sig[i]
            guard v > noise else { continue }
            let neighbourhood = sig[(i - window)...(i + window)]
            guard v == neighbourhood.max() else { continue }
            if let last = peaks.last, i - last < minDist { continue }
            peaks.append(i)
        }

        guard peaks.count >= 2 else { return 0 }

        var intervals: [Double] = []
        for i in 1..<peaks.count {
            let ivl = Double(peaks[i] - peaks[i - 1]) / 30.0
            if ivl >= 0.3 && ivl <= 1.33 { intervals.append(ivl) }
        }
        guard !intervals.isEmpty else { return 0 }

        let avgInterval = intervals.reduce(0, +) / Double(intervals.count)
        return max(45, min(200, Int(60.0 / avgInterval)))
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraHeartRateService: AVCaptureVideoDataOutputSampleBufferDelegate {
    nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pb = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let avgRed = averageRed(in: pb)
        Task { @MainActor [weak self] in self?.process(avgRed: avgRed) }
    }
}
