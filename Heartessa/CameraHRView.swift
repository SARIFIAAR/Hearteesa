import SwiftUI
import AVFoundation

// MARK: - Camera HR Measurement View (Screens 5 + 5A)

struct CameraHRView: View {
    let onComplete: (Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @StateObject private var service = CameraHeartRateService()

    @State private var ringAngle: Double = 0

    // MARK: - Computed helpers

    private var isCameraActive: Bool {
        switch service.state {
        case .idle, .error: return false
        default:            return true
        }
    }

    private var currentStep: Int {
        switch service.state {
        case .idle, .cameraOpen, .error: return 1
        case .detecting:                  return 2
        case .measuring, .complete:       return 3
        }
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            ZStack {
                DS.Color.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    headerRow(w: w)
                    subtitleRow
                        .padding(.top, w * 0.025)
                    stepRow(w: w)
                        .padding(.horizontal, w * 0.07)
                        .padding(.top, w * 0.04)
                    orbView(w: w)
                        .padding(.top, w * 0.055)
                    belowOrbLabel(w: w)
                        .padding(.top, w * 0.025)
                    instructionBlock(w: w)
                        .padding(.top, w * 0.045)
                        .padding(.horizontal, w * 0.07)
                    tipCard(w: w)
                        .padding(.top, w * 0.035)
                        .padding(.horizontal, w * 0.07)
                    Button("How to measure ?") {}
                        .font(DS.Font.mono(12))
                        .foregroundStyle(DS.Color.red)
                        .padding(.top, w * 0.035)
                    Spacer(minLength: 0)
                    actionButton(w: w)
                        .padding(.horizontal, w * 0.07)
                        .padding(.bottom, w * 0.08)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                ringAngle = 360
            }
        }
        .onChange(of: service.state) { _, newState in
            switch newState {
            case .cameraOpen:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    service.beginMeasurement()
                }
            case .complete(let bpm):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    onComplete(bpm)
                    dismiss()
                }
            default:
                break
            }
        }
        .onDisappear { service.stop() }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private func headerRow(w: CGFloat) -> some View {
        HStack {
            Button { service.stop(); dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(DS.Color.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(DS.Color.card)
                    .clipShape(Circle())
            }
            Spacer()
            Text("Record Heart Rate")
                .font(DS.Font.grotesk(16, weight: .medium))
                .foregroundStyle(DS.Color.textPrimary)
            Spacer()
            // Flash indicator — glows red when torch is on
            ZStack {
                Circle()
                    .fill(DS.Color.card)
                    .frame(width: 36, height: 36)
                Image(systemName: "bolt.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(isCameraActive ? DS.Color.red : DS.Color.textMuted)
            }
            .shadow(color: isCameraActive ? DS.Color.red.opacity(0.5) : .clear, radius: 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Subtitle

    private var subtitleRow: some View {
        Text("HEART RATE · CAMERA")
            .font(DS.Font.mono(10))
            .foregroundStyle(DS.Color.textMuted)
    }

    // MARK: - Step indicator

    private func stepRow(w: CGFloat) -> some View {
        HStack(spacing: 0) {
            stepLabel(n: 1, text: "Place finger", active: currentStep == 1)
            Spacer()
            Text("→").font(DS.Font.mono(10)).foregroundStyle(DS.Color.textMuted.opacity(0.5))
            Spacer()
            stepLabel(n: 2, text: "Find pulse",   active: currentStep == 2)
            Spacer()
            Text("→").font(DS.Font.mono(10)).foregroundStyle(DS.Color.textMuted.opacity(0.5))
            Spacer()
            stepLabel(n: 3, text: "Record",        active: currentStep == 3)
        }
    }

    private func stepLabel(n: Int, text: String, active: Bool) -> some View {
        HStack(spacing: 4) {
            Text(["①","②","③"][n - 1])
            Text(text)
        }
        .font(DS.Font.mono(10))
        .foregroundStyle(active ? DS.Color.red : DS.Color.textMuted)
        .animation(.easeInOut(duration: 0.3), value: active)
    }

    // MARK: - Orb

    private func orbView(w: CGFloat) -> some View {
        let orbSize: CGFloat = w * 0.60

        return ZStack {
            // Outer diffuse glow
            Circle()
                .stroke(DS.Color.red.opacity(0.06), lineWidth: 28)
                .frame(width: orbSize + 28, height: orbSize + 28)

            // Animated arc ring (particle effect)
            Circle()
                .trim(from: 0, to: 0.80)
                .stroke(
                    AngularGradient(
                        colors: [DS.Color.red.opacity(0.05), DS.Color.red.opacity(0.85), DS.Color.red.opacity(0.05)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [4, 6])
                )
                .frame(width: orbSize, height: orbSize)
                .rotationEffect(.degrees(ringAngle))

            // Secondary thin ring (static)
            Circle()
                .stroke(DS.Color.red.opacity(0.20), lineWidth: 1)
                .frame(width: orbSize, height: orbSize)

            // Dark interior fill
            Circle()
                .fill(DS.Color.background)
                .frame(width: orbSize - 6, height: orbSize - 6)

            // Content
            orbContent(orbSize: orbSize - 6)
        }
    }

    @ViewBuilder
    private func orbContent(orbSize: CGFloat) -> some View {
        if isCameraActive {
            ZStack {
                CameraPreviewView(session: service.session)
                    .frame(width: orbSize, height: orbSize)
                    .clipShape(Circle())
                orbActiveOverlay(orbSize: orbSize)
            }
        } else {
            // Idle
            Text("PLACE FINGER\nON LENS")
                .font(DS.Font.mono(10))
                .foregroundStyle(DS.Color.textMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }

    @ViewBuilder
    private func orbActiveOverlay(orbSize: CGFloat) -> some View {
        switch service.state {
        case .cameraOpen, .detecting:
            if !service.fingerDetected {
                Text("Cover lens")
                    .font(DS.Font.mono(9))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color.black.opacity(0.65))
                    .clipShape(Capsule())
            }
        case .measuring(let bpm):
            VStack(spacing: 2) {
                Text(bpm > 0 ? "\(bpm)" : "—")
                    .font(DS.Font.grotesk(38, weight: .light))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .shadow(color: .black.opacity(0.6), radius: 4)
                Text("BPM")
                    .font(DS.Font.mono(10))
                    .foregroundStyle(.white.opacity(0.75))
                    .shadow(color: .black.opacity(0.6), radius: 2)
            }
        case .complete(let bpm):
            VStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(DS.Color.catNormal)
                Text("\(bpm) BPM")
                    .font(DS.Font.grotesk(18, weight: .medium))
                    .foregroundStyle(.white)
            }
        default:
            EmptyView()
        }
    }

    // MARK: - Below-orb label (Screen 5A)

    @ViewBuilder
    private func belowOrbLabel(w: CGFloat) -> some View {
        if isCameraActive {
            Text("COVER THE REAR LENS")
                .font(DS.Font.mono(9))
                .foregroundStyle(DS.Color.textMuted)
        } else {
            Spacer().frame(height: 16)
        }
    }

    // MARK: - Instructions

    private func instructionBlock(w: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(instructionHeading)
                .font(DS.Font.grotesk(22, weight: .light))
                .foregroundStyle(DS.Color.textPrimary)
            Text(instructionBody)
                .font(DS.Font.grotesk(13))
                .foregroundStyle(DS.Color.textSecondary)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut(duration: 0.25), value: service.state == .idle)
    }

    private var instructionHeading: String {
        switch service.state {
        case .idle:               return "Cover the camera lens."
        case .cameraOpen:         return "Cover the camera lens."
        case .detecting:          return "Hold still."
        case .measuring:          return "Keep your finger on."
        case .complete:           return "Measurement complete."
        case .error:              return "Something went wrong."
        }
    }

    private var instructionBody: String {
        switch service.state {
        case .idle:
            return "Rest your fingertip lightly over the rear camera lens."
        case .cameraOpen:
            return "Press your fingertip gently over the rear camera and flash."
        case .detecting:
            return "Keep your fingertip pressed over the camera. Finding your pulse..."
        case .measuring:
            return "Stay still. Your heart rate is being recorded."
        case .complete:
            return "Your heart rate reading is ready."
        case .error(let msg):
            return msg
        }
    }

    // MARK: - Tip card

    private func tipCard(w: CGFloat) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(DS.Color.red.opacity(0.14))
                    .frame(width: 52, height: 52)
                Image(systemName: isCameraActive ? "camera.viewfinder" : "hand.point.up.left.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(DS.Color.red)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(tipBold)
                    .font(DS.Font.grotesk(13, weight: .medium))
                    .foregroundStyle(DS.Color.textPrimary)
                Text(tipBody)
                    .font(DS.Font.grotesk(12))
                    .foregroundStyle(DS.Color.textSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .background(DS.Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var tipBold: String {
        switch service.state {
        case .cameraOpen, .detecting: return "Watch the camera view."
        case .measuring:               return "Keep steady."
        default:                       return "A light touch is enough."
        }
    }

    private var tipBody: String {
        switch service.state {
        case .cameraOpen, .detecting:
            return "Cover the lens until the preview turns red or dark. Keep a light touch."
        case .measuring:
            return "Don't move your hand until the recording is complete."
        default:
            return "Cover the camera lens fully. Rest your arm and keep your finger still."
        }
    }

    // MARK: - Action button

    @ViewBuilder
    private func actionButton(w: CGFloat) -> some View {
        switch service.state {
        case .idle:
            Button { service.requestCameraAndStart() } label: {
                HStack(spacing: 10) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(DS.Color.red)
                    Text("Start")
                        .font(DS.Font.grotesk(16, weight: .medium))
                    Text("› › ›")
                        .font(DS.Font.mono(13))
                        .foregroundStyle(DS.Color.textMuted)
                }
                .foregroundStyle(DS.Color.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(DS.Color.card)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(DS.Color.separator, lineWidth: 1)
                )
            }

        case .cameraOpen, .detecting:
            Button { service.stop() } label: {
                Text("Cancel")
                    .font(DS.Font.label)
                    .foregroundStyle(DS.Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(DS.Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

        case .measuring:
            // Progress bar as button background
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(DS.Color.card)
                    .frame(height: 54)
                GeometryReader { g in
                    RoundedRectangle(cornerRadius: 14)
                        .fill(DS.Color.red.opacity(0.25))
                        .frame(width: g.size.width * service.progress)
                        .animation(.linear(duration: 0.1), value: service.progress)
                }
                .frame(height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                Text("Recording...")
                    .font(DS.Font.label)
                    .foregroundStyle(DS.Color.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 54)

        case .complete:
            EmptyView()

        case .error:
            Button {
                service.stop()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    service.requestCameraAndStart()
                }
            } label: {
                Text("Try Again")
                    .font(DS.Font.label)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(DS.Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}

// MARK: - AVCaptureVideoPreviewLayer wrapper

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let v = PreviewUIView()
        v.videoPreviewLayer.session      = session
        v.videoPreviewLayer.videoGravity = .resizeAspectFill
        return v
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {}

    final class PreviewUIView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}
