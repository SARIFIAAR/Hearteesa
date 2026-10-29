import Foundation
import SwiftData

enum Arm: String, Codable, CaseIterable {
    case left = "Left"
    case right = "Right"
    case unspecified = "—"
}

enum Position: String, Codable, CaseIterable {
    case sitting = "Sitting"
    case standing = "Standing"
    case lying = "Lying"
    case unspecified = "—"
}

enum BPCategory: String, Codable {
    case normal        = "Normal"
    case elevated      = "Elevated"
    case highStage1    = "High Stage 1"
    case highStage2    = "High Stage 2"
    case ish           = "Isolated Systolic Hypertension"
    case hypotension   = "Hypotension"
    case crisis        = "Hypertensive Crisis"

    static func classify(systolic: Int, diastolic: Int) -> BPCategory {
        if systolic >= 180 || diastolic >= 120 { return .crisis }
        if systolic >= 140 && diastolic < 90   { return .ish }
        if systolic >= 140 || diastolic >= 90  { return .highStage2 }
        if systolic >= 130 || diastolic >= 80  { return .highStage1 }
        if systolic >= 120 && diastolic < 80   { return .elevated }
        if systolic < 90  || diastolic < 60    { return .hypotension }
        return .normal
    }
}

@Model
final class BPReading {
    var id: UUID
    var systolic: Int
    var diastolic: Int
    var pulse: Int
    var timestamp: Date
    var arm: Arm
    var position: Position
    var notes: String
    var tags: [String]
    var weight: Double?

    var category: BPCategory {
        BPCategory.classify(systolic: systolic, diastolic: diastolic)
    }

    var isMorningReading: Bool {
        Calendar.current.component(.hour, from: timestamp) < 12
    }

    init(
        systolic: Int,
        diastolic: Int,
        pulse: Int,
        timestamp: Date = .now,
        arm: Arm = .unspecified,
        position: Position = .unspecified,
        notes: String = "",
        tags: [String] = [],
        weight: Double? = nil
    ) {
        self.id = UUID()
        self.systolic = systolic
        self.diastolic = diastolic
        self.pulse = pulse
        self.timestamp = timestamp
        self.arm = arm
        self.position = position
        self.notes = notes
        self.tags = tags
        self.weight = weight
    }
}
