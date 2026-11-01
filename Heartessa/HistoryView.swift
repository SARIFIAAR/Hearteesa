import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \BPReading.timestamp, order: .reverse) private var readings: [BPReading]
    @Environment(\.modelContext) private var context

    @State private var pendingDeleteID: PersistentIdentifier?
    @State private var pendingDeleteReading: BPReading?
    @State private var showUndoToast = false
    @State private var showExportMenu = false
    @State private var shareItems: [Any] = []
    @State private var showShareSheet = false
    @State private var selectedReading: BPReading?

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
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Text("History")
                        .font(DS.Font.heading)
                        .foregroundStyle(DS.Color.textPrimary)
                    Spacer()
                    Button {
                        showExportMenu = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 13))
                            Text("Export")
                                .font(DS.Font.caption)
                        }
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(DS.Color.card)
                        .clipShape(Capsule())
                    }
                }
                .padding(.bottom, 20)

                if readings.isEmpty {
                    HistoryEmptyState()
                        .padding(.top, 40)
                } else {
                    VStack(spacing: 24) {
                        ForEach(grouped, id: \.key) { group in
                            HistoryDaySection(
                                date: group.key,
                                readings: group.readings,
                                onTap: { selectedReading = $0 },
                                onDelete: { softDelete($0) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
        .background(DS.Color.background.ignoresSafeArea())
        .navigationDestination(item: $selectedReading) { reading in
            ReadingResultView(reading: reading, showSuccess: false)
        }
        .overlay(alignment: .bottom) {
            if showUndoToast {
                DSUndoToast {
                    pendingDeleteID = nil
                    pendingDeleteReading = nil
                    showUndoToast = false
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding(.bottom, 104)
                .padding(.horizontal, 20)
            }
        }
        .animation(.spring(duration: 0.3), value: showUndoToast)
        .confirmationDialog("Export Readings", isPresented: $showExportMenu, titleVisibility: .visible) {
            Button("Export as PDF") { prepareExport(format: .pdf) }
            Button("Export as CSV") { prepareExport(format: .csv) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All \(readings.count) reading\(readings.count == 1 ? "" : "s") will be included.")
        }
        .sheet(isPresented: $showShareSheet) {
            HistoryShareSheet(items: shareItems)
                .ignoresSafeArea()
        }
        } // NavigationStack
    }

    private enum ExportFormat { case pdf, csv }

    private func prepareExport(format: ExportFormat) {
        let all = Array(readings)
        let tmp = FileManager.default.temporaryDirectory
        switch format {
        case .pdf:
            let url = tmp.appendingPathComponent("heartessa-bp-report.pdf")
            try? ExportService.pdfData(readings: all).write(to: url)
            shareItems = [url]
        case .csv:
            let url = tmp.appendingPathComponent("heartessa-bp-readings.csv")
            try? ExportService.csvData(readings: all).write(to: url)
            shareItems = [url]
        }
        showShareSheet = true
    }

    private func softDelete(_ reading: BPReading) {
        pendingDeleteID = reading.persistentModelID
        pendingDeleteReading = reading
        showUndoToast = true

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(4))
            guard showUndoToast else { return }
            showUndoToast = false
            if let r = pendingDeleteReading { context.delete(r) }
            pendingDeleteID = nil
            pendingDeleteReading = nil
        }
    }
}

// MARK: - Day Section

struct HistoryDaySection: View {
    let date: Date
    let readings: [BPReading]
    let onTap: (BPReading) -> Void
    let onDelete: (BPReading) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(sectionTitle)
                .font(DS.Font.mono(11))
                .foregroundStyle(DS.Color.textMuted)

            VStack(spacing: 0) {
                ForEach(Array(readings.enumerated()), id: \.element.id) { idx, reading in
                    HistoryReadingRow(reading: reading, onTap: { onTap(reading) }, onDelete: { onDelete(reading) })

                    if idx < readings.count - 1 {
                        Divider()
                            .background(DS.Color.separator)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .heartessaCard()
        }
    }

    private var sectionTitle: String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "TODAY" }
        if cal.isDateInYesterday(date) { return "YESTERDAY" }
        return date.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased()
    }
}

// MARK: - Row

struct HistoryReadingRow: View {
    let reading: BPReading
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Button(action: onTap) { rowContent }
            .buttonStyle(.plain)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
    }

    private var rowContent: some View {
        HStack(spacing: 12) {
            // Time
            Text(reading.timestamp.formatted(date: .omitted, time: .shortened))
                .font(DS.Font.mono(11))
                .foregroundStyle(DS.Color.textSecondary)
                .frame(width: 52, alignment: .leading)

            // Numbers
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(reading.systolic)/\(reading.diastolic)")
                    .font(DS.Font.grotesk(18, weight: .regular))
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
                Text("mmHg")
                    .font(DS.Font.mono(10))
                    .foregroundStyle(DS.Color.textMuted)
            }

            Spacer()

            // Category + pulse
            VStack(alignment: .trailing, spacing: 4) {
                AnyBPBadge(systolic: reading.systolic, diastolic: reading.diastolic)
                Text("\(reading.pulse) bpm")
                    .font(DS.Font.mono(10))
                    .foregroundStyle(DS.Color.textMuted)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Empty State

struct HistoryEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(DS.Color.card)
                    .frame(width: 64, height: 64)
                Image(systemName: "calendar")
                    .font(.system(size: 26))
                    .foregroundStyle(DS.Color.textSecondary)
            }
            Text("No history yet")
                .font(DS.Font.label)
                .foregroundStyle(DS.Color.textSecondary)
            Text("Readings you log will appear here.")
                .font(DS.Font.micro)
                .foregroundStyle(DS.Color.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Undo Toast

struct DSUndoToast: View {
    let onUndo: () -> Void

    var body: some View {
        HStack {
            Text("Reading deleted")
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textSecondary)
            Spacer()
            Button("Undo", action: onUndo)
                .font(DS.Font.label)
                .foregroundStyle(DS.Color.red)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(DS.Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Share Sheet

import UIKit

struct HistoryShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
