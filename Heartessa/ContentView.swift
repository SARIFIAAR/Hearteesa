import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \BPReading.timestamp, order: .reverse) private var readings: [BPReading]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "heart.fill") }

            HistoryView()
                .tabItem { Label("History", systemImage: "list.bullet") }

            Text("Chart")
                .tabItem { Label("Chart", systemImage: "chart.line.uptrend.xyaxis") }

            Text("More")
                .tabItem { Label("More", systemImage: "ellipsis") }
        }
    }
}

// MARK: - Home

struct HomeView: View {
    @Query(sort: \BPReading.timestamp, order: .reverse) private var readings: [BPReading]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let latest = readings.first {
                        ReadingCard(reading: latest)
                    } else {
                        EmptyStateCard()
                    }
                }
                .padding()
            }
            .navigationTitle("Heartessa")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        AddReadingView()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }
}

// MARK: - History

struct HistoryView: View {
    @Query(sort: \BPReading.timestamp, order: .reverse) private var readings: [BPReading]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(readings) { reading in
                    ReadingRow(reading: reading)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("History")
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(readings[index])
        }
    }
}

// MARK: - Add Reading

struct AddReadingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var systolic: Int = 120
    @State private var diastolic: Int = 80
    @State private var pulse: Int = 70
    @State private var arm: Arm = .unspecified
    @State private var position: Position = .unspecified
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Reading") {
                    NumberField(label: "Systolic", value: $systolic, range: 60...250)
                    NumberField(label: "Diastolic", value: $diastolic, range: 40...160)
                    NumberField(label: "Pulse", value: $pulse, range: 30...220)
                }

                Section("Details") {
                    Picker("Arm", selection: $arm) {
                        ForEach(Arm.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    .pickerStyle(.segmented)

                    Picker("Position", selection: $position) {
                        ForEach(Position.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        let reading = BPReading(
            systolic: systolic,
            diastolic: diastolic,
            pulse: pulse,
            arm: arm,
            position: position,
            notes: notes
        )
        modelContext.insert(reading)
        dismiss()
    }
}

// MARK: - Components

struct ReadingCard: View {
    let reading: BPReading

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(reading.systolic)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text("/")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("\(reading.diastolic)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Spacer()
                CategoryBadge(category: reading.category)
            }
            HStack {
                Label("\(reading.pulse) bpm", systemImage: "waveform.path.ecg")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(reading.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct ReadingRow: View {
    let reading: BPReading

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(reading.systolic)/\(reading.diastolic)")
                    .font(.headline)
                    .monospacedDigit()
                Text(reading.timestamp, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            CategoryBadge(category: reading.category)
        }
    }
}

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

    private var categoryColor: Color {
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

struct NumberField: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField(label, value: $value, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
        }
    }
}

struct EmptyStateCard: View {
    var body: some View {
        ContentUnavailableView(
            "No Readings Yet",
            systemImage: "heart.text.clipboard",
            description: Text("Tap + to log your first blood pressure reading.")
        )
    }
}

// MARK: - Color extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [BPReading.self, UserProfile.self], inMemory: true)
}
