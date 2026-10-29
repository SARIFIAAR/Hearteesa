import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \BPReading.timestamp, order: .reverse) private var readings: [BPReading]
    @Environment(\.modelContext) private var context

    @State private var pendingDeleteID: PersistentIdentifier?
    @State private var pendingDeleteReading: BPReading?
    @State private var showUndoToast = false

    private var visible: [BPReading] {
        readings.filter { $0.persistentModelID != pendingDeleteID }
    }

    private var grouped: [(key: Date, readings: [BPReading])] {
        let cal = Calendar.current
        let dict = Dictionary(grouping: visible) { cal.startOfDay(for: $0.timestamp) }
        return dict.sorted { $0.key > $1.key }.map { (key: $0.key, readings: $0.value) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if readings.isEmpty {
                    ContentUnavailableView(
                        "No Readings",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Log your first reading from the Home tab.")
                    )
                } else {
                    List {
                        ForEach(grouped, id: \.key) { group in
                            Section(group.key.formatted(.dateTime.weekday(.wide).month(.wide).day().year())) {
                                ForEach(group.readings) { reading in
                                    ReadingRow(reading: reading)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                softDelete(reading)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("History")
            .overlay(alignment: .bottom) {
                if showUndoToast {
                    UndoToast {
                        pendingDeleteID = nil
                        pendingDeleteReading = nil
                        showUndoToast = false
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 24)
                }
            }
            .animation(.spring(duration: 0.3), value: showUndoToast)
        }
    }

    private func softDelete(_ reading: BPReading) {
        pendingDeleteID = reading.persistentModelID
        pendingDeleteReading = reading
        showUndoToast = true

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(4))
            guard showUndoToast else { return }
            showUndoToast = false
            if let r = pendingDeleteReading {
                context.delete(r)
            }
            pendingDeleteID = nil
            pendingDeleteReading = nil
        }
    }
}

// MARK: - Row

struct ReadingRow: View {
    let reading: BPReading

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(reading.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption).foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text("\(reading.systolic)/\(reading.diastolic)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .monospacedDigit()
                    Text("mmHg").font(.caption2).foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {
                CategoryBadge(category: reading.category)
                HStack(spacing: 6) {
                    if reading.arm != .unspecified {
                        Text(reading.arm == .left ? "L" : "R")
                            .font(.caption2)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(.quaternary, in: Capsule())
                    }
                    if reading.position != .unspecified {
                        Image(systemName: positionIcon(reading.position))
                            .font(.caption2).foregroundStyle(.secondary)
                    }
                    Text("\(reading.pulse) bpm").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 3)
    }

    private func positionIcon(_ pos: Position) -> String {
        switch pos {
        case .sitting: "chair"
        case .standing: "figure.stand"
        case .lying: "bed.double"
        case .unspecified: "questionmark"
        }
    }
}

// MARK: - Undo Toast

struct UndoToast: View {
    let onUndo: () -> Void

    var body: some View {
        HStack {
            Text("Reading deleted").font(.subheadline)
            Spacer()
            Button("Undo", action: onUndo)
                .font(.subheadline).fontWeight(.semibold)
                .tint(Color(hex: "#2D9D6E"))
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, y: 2)
        .padding(.horizontal, 24)
    }
}
