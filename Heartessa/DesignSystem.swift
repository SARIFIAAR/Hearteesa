import SwiftUI

// MARK: - Heartessa Design System
// bg #080909 · card #1C1C1E · red #E5583A · Space Grotesk + Share Tech Mono
// NO blur, NO backdrop-filter, NO frosted glass anywhere

enum DS {

    // MARK: - Colors
    enum Color {
        static let background   = SwiftUI.Color(hex: "#080909")
        static let card         = SwiftUI.Color(hex: "#1C1C1E")
        static let cardDark     = SwiftUI.Color(hex: "#0B0E0C")
        static let red          = SwiftUI.Color(hex: "#E5583A")
        static let redGlow      = SwiftUI.Color(hex: "#E5583A").opacity(0.14)

        static let textPrimary      = SwiftUI.Color.white
        static let textSecondary    = SwiftUI.Color.white.opacity(0.6)
        static let textTertiary     = SwiftUI.Color.white.opacity(0.4)
        static let textMuted        = SwiftUI.Color.white.opacity(0.25)

        static let separator    = SwiftUI.Color.white.opacity(0.08)
        static let tabBar       = SwiftUI.Color(hex: "#0F0F10")

        // Category badge colors
        static let catNormal    = SwiftUI.Color(hex: "#34C759")
        static let catElevated  = SwiftUI.Color(hex: "#F0A500")
        static let catStage1    = SwiftUI.Color(hex: "#FF6B35")
        static let catStage2    = SwiftUI.Color(hex: "#E5583A")
        static let catCrisis    = SwiftUI.Color(hex: "#8B0000")
        static let catHypo      = SwiftUI.Color(hex: "#2563B8")
        static let catISH       = SwiftUI.Color(hex: "#7B3DBD")
        static let catESCNormal = SwiftUI.Color(hex: "#28C06D")
    }

    // MARK: - Typography
    enum Font {
        static func grotesk(_ size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            .custom("SpaceGrotesk-Regular", size: size).weight(weight)
        }
        static func mono(_ size: CGFloat) -> SwiftUI.Font {
            .custom("ShareTechMono-Regular", size: size)
        }

        static let heroNumber   = grotesk(72, weight: .light)
        static let heroSub      = grotesk(42, weight: .light)
        static let heading      = grotesk(32, weight: .light)
        static let subheading   = grotesk(20, weight: .regular)
        static let label        = grotesk(14, weight: .medium)
        static let caption      = grotesk(12, weight: .regular)
        static let micro        = grotesk(11, weight: .regular)

        static let monoData     = mono(13)
        static let monoSmall    = mono(11)
    }

    // MARK: - Spacing
    enum Space {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    // MARK: - Radius
    enum Radius {
        static let card: CGFloat = 16
        static let chip: CGFloat = 100
        static let tab:  CGFloat = 100
    }
}

// MARK: - Card Modifier
struct HeartessaCard: ViewModifier {
    var color: Color = DS.Color.card
    func body(content: Content) -> some View {
        content
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.card))
    }
}

extension View {
    func heartessaCard(color: Color = DS.Color.card) -> some View {
        modifier(HeartessaCard(color: color))
    }
}

// MARK: - Category Badge
struct CategoryBadgeDS: View {
    let category: BPCategory

    var body: some View {
        Text(category.rawValue)
            .font(DS.Font.caption)
            .fontWeight(.semibold)
            .foregroundStyle(badgeColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(badgeColor.opacity(0.18))
            .clipShape(Capsule())
    }

    var badgeColor: Color {
        switch category {
        case .normal:      DS.Color.catNormal
        case .elevated:    DS.Color.catElevated
        case .highStage1:  DS.Color.catStage1
        case .highStage2:  DS.Color.catStage2
        case .crisis:      DS.Color.catCrisis
        case .hypotension: DS.Color.catHypo
        case .ish:         DS.Color.catISH
        }
    }
}

// MARK: - BP Standard

enum BPStandard: String {
    case acc = "acc"
    case esc = "esc"
    static let storageKey = "heartessa.bpStandard"
}

// MARK: - ESC Category Badge

struct ESCCategoryBadgeDS: View {
    let category: ESCCategory

    var body: some View {
        Text(category.rawValue)
            .font(DS.Font.caption)
            .fontWeight(.semibold)
            .foregroundStyle(badgeColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(badgeColor.opacity(0.18))
            .clipShape(Capsule())
    }

    var badgeColor: Color {
        switch category {
        case .optimal:     DS.Color.catNormal
        case .normal:      DS.Color.catESCNormal
        case .highNormal:  DS.Color.catElevated
        case .grade1:      DS.Color.catStage1
        case .grade2:      DS.Color.catStage2
        case .grade3:      DS.Color.catCrisis
        case .hypotension: DS.Color.catHypo
        }
    }
}

// MARK: - Standard-aware badge

struct AnyBPBadge: View {
    let systolic: Int
    let diastolic: Int
    @AppStorage(BPStandard.storageKey) private var standard = BPStandard.acc.rawValue

    var body: some View {
        if standard == BPStandard.esc.rawValue {
            ESCCategoryBadgeDS(category: ESCCategory.classify(systolic: systolic, diastolic: diastolic))
        } else {
            CategoryBadgeDS(category: BPCategory.classify(systolic: systolic, diastolic: diastolic))
        }
    }
}

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDestructive = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Font.label)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(isDestructive ? Color(hex: "#C0392B") : DS.Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Ghost Button
struct GhostButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textSecondary)
        }
    }
}

// Color(hex:) lives in Shared/ColorHex.swift (shared with Watch + Complication)
