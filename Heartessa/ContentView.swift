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
    let category: BPCategory

    var body: some View {
        Text(category.rawValue)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(categoryColor.opacity(0.15), in: Capsule())
            .foregroundStyle(categoryColor)
    }

    var categoryColor: Color {
        switch category {
        case .normal:      return Color(hex: "#2D9D6E")
        case .elevated:    return Color(hex: "#C9860A")
        case .highStage1:  return Color(hex: "#D4621A")
        case .highStage2:  return Color(hex: "#C02828")
        case .ish:         return Color(hex: "#7B3DBD")
        case .hypotension: return Color(hex: "#2563B8")
        case .crisis:      return Color(hex: "#8B0000")
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
