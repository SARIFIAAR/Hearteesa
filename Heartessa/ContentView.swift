import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "heart.fill") }
            HistoryView()
                .tabItem { Label("History", systemImage: "list.bullet") }
            ChartView()
                .tabItem { Label("Trends", systemImage: "chart.line.uptrend.xyaxis") }
            MoreView()
                .tabItem { Label("More", systemImage: "ellipsis.circle") }
        }
        .tint(Color(hex: "#2D9D6E"))
    }
}

// MARK: - Shared Components

struct CategoryBadge: View {
    let systolic: Int
    let diastolic: Int
    @AppStorage("heartessa.bpStandard") private var standard = "accaha"

    init(systolic: Int, diastolic: Int) {
        self.systolic = systolic
        self.diastolic = diastolic
    }

    init(reading: BPReading) {
        self.systolic = reading.systolic
        self.diastolic = reading.diastolic
    }

    var body: some View {
        Text(label)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.15), in: Capsule())
            .foregroundStyle(badgeColor)
    }

    private var label: String {
        if standard == "esc2018" {
            return ESCCategory.classify(systolic: systolic, diastolic: diastolic).rawValue
        }
        return BPCategory.classify(systolic: systolic, diastolic: diastolic).rawValue
    }

    private var badgeColor: Color {
        if standard == "esc2018" {
            return escColor(ESCCategory.classify(systolic: systolic, diastolic: diastolic))
        }
        return accColor(BPCategory.classify(systolic: systolic, diastolic: diastolic))
    }

    private func accColor(_ c: BPCategory) -> Color {
        switch c {
        case .normal:      Color(hex: "#2D9D6E")
        case .elevated:    Color(hex: "#C9860A")
        case .highStage1:  Color(hex: "#D4621A")
        case .highStage2:  Color(hex: "#C02828")
        case .ish:         Color(hex: "#7B3DBD")
        case .hypotension: Color(hex: "#2563B8")
        case .crisis:      Color(hex: "#8B0000")
        }
    }

    private func escColor(_ c: ESCCategory) -> Color {
        switch c {
        case .optimal:     Color(hex: "#2D9D6E")
        case .normal:      Color(hex: "#56B87C")
        case .highNormal:  Color(hex: "#C9860A")
        case .grade1:      Color(hex: "#D4621A")
        case .grade2:      Color(hex: "#C02828")
        case .grade3:      Color(hex: "#8B0000")
        case .hypotension: Color(hex: "#2563B8")
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double( int        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [BPReading.self, UserProfile.self], inMemory: true)
}
