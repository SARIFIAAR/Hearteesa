import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class FirestoreService {
    static let shared = FirestoreService()

    private let db = Firestore.firestore()
    private var cachedUID: String?

    private init() {}

    // MARK: - Sync

    func syncReading(_ reading: BPReading) async {
        guard let uid = await ensureUID() else { return }
        let ref = db.collection("users").document(uid)
                    .collection("readings").document(reading.id.uuidString)
        let data: [String: Any] = [
            "id": reading.id.uuidString,
            "systolic": reading.systolic,
            "diastolic": reading.diastolic,
            "pulse": reading.pulse,
            "timestamp": Timestamp(date: reading.timestamp),
            "arm": reading.arm.rawValue,
            "position": reading.position.rawValue,
            "notes": reading.notes,
            "category": reading.category.rawValue
        ]
        try? await ref.setData(data)
    }

    func deleteReading(id: UUID) async {
        guard let uid = await ensureUID() else { return }
        let ref = db.collection("users").document(uid)
                    .collection("readings").document(id.uuidString)
        try? await ref.delete()
    }

    // MARK: - Auth

    private func ensureUID() async -> String? {
        if let uid = cachedUID { return uid }
        if let existing = Auth.auth().currentUser?.uid {
            cachedUID = existing
            return existing
        }
        if let result = try? await Auth.auth().signInAnonymously() {
            cachedUID = result.user.uid
            return cachedUID
        }
        return nil
    }
}
