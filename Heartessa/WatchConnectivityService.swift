import Foundation
import WatchConnectivity

@MainActor
final class WatchConnectivityService: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityService()

    var onReadingReceived: ((BPReading) -> Void)?

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func sendLatestReading(_ reading: BPReading) {
        guard WCSession.default.isReachable else { return }
        let payload: [String: Any] = [
            "systolic": reading.systolic,
            "diastolic": reading.diastolic,
            "pulse": reading.pulse,
            "timestamp": reading.timestamp.timeIntervalSince1970,
            "category": reading.category.rawValue
        ]
        WCSession.default.sendMessage(payload, replyHandler: nil, errorHandler: nil)
    }

    // MARK: - WCSessionDelegate

    nonisolated func session(_ session: WCSession,
                             activationDidCompleteWith state: WCSessionActivationState,
                             error: Error?) {}

    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    nonisolated func session(_ session: WCSession,
                             didReceiveMessage message: [String: Any]) {
        guard
            let sys = message["systolic"] as? Int,
            let dia = message["diastolic"] as? Int,
            let pulse = message["pulse"] as? Int,
            let ts = message["timestamp"] as? TimeInterval
        else { return }

        let reading = BPReading(
            systolic: sys, diastolic: dia, pulse: pulse,
            timestamp: Date(timeIntervalSince1970: ts))

        Task { @MainActor in
            self.onReadingReceived?(reading)
        }
    }
}
