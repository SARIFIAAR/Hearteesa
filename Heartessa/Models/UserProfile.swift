import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var colorHex: String
    var isDefault: Bool
    var createdAt: Date

    init(name: String, colorHex: String = "#2D9D6E", isDefault: Bool = false) {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.isDefault = isDefault
        self.createdAt = .now
    }
}
