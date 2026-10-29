import SwiftUI
import SwiftData
import Charts

enum ChartPeriod: String, CaseIterable {
    case week = "7D"
    case month = "30D"
    case quarter = "90D"

    var days: Int {
        switch self { case .week: 7; case .month: 30; case .quarter: 90 }
    }
}

struct ChartView: View {
    @Query(sort: \BPReading.timestamp, order: .reverse) private var all: [BPReading]
    @State private var period: ChartPeriod = .week

    private var filtered: [BPReading] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -period.days, to: Date())!
        return all.filter { $0.timestamp >= cutoff }.sorted { $0.timestamp < $1.timestamp }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Period", selection: $period) {
                        ForEach(ChartPeriod.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    BPLineChart(readings: filtered)
                        .frame(height: 220)
                        .padding(.horizontal)

                    StatsBar(readings: filtered)
                        .padding(.horizontal)

                    AMPMSplitCards(readings: filtered)
                        .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Trends")
        }
    }
}

// MARK: - Line Chart

struct BPLineChart: View {
    let readings: [BPReading]

    var body: some View {
        if readings.isEmpty {
            ContentUnavailableView(
                "No Data",
                systemImage: "chart.line.uptrend.xyaxis",
                description: Text("Add at least 2 readings to see your trend.")
            )
        } else {
            Chart {
                ForEach(readings) { r in
                    LineMark(
                        x: .value("Date", r.timestamp),
                        y: .value("Systolic", r.systolic),
                        series: .value("Metric", "Systolic")
                    )
                    .foregroundStyle(.red)
                    .interpolationMethod(.catmullRom)

                    PointMark(x: .value("Date", r.timestamp), y: .value("Systolic", r.systolic))
                        .foregroundStyle(.red).symbolSize(25)

                    LineMark(
                        x: .value("Date", r.timestamp),
                        y: .value("Diastolic", r.diastolic),
                        series: .value("Metric", "Diastolic")
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)

                    PointMark(x: .value("Date", r.timestamp), y: .value("Diastolic", r.diastolic))
                        .foregroundStyle(.blue).symbolSize(25)
                }

                RuleMark(y: .value("Normal Sys", 120))
                    .foregroundStyle(.red.opacity(0.25))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                RuleMark(y: .value("Normal Dia", 80))
                    .foregroundStyle(.blue.opacity(0.25))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
            }
            .chartYAxis { AxisMarks(position: .leading) }
            .chartYScale(domain: .automatic(includesZero: false))
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Stats Bar

struct StatsBar: View {
    let readings: [BPReading]

    private var avgSys: Int {
        readings.isEmpty ? 0 : readings.map(\.systolic).reduce(0, +) / readings.count
    }
    private var avgDia: Int {
        readings.isEmpty ? 0 : readings.map(\.diastolic).reduce(0, +) / readings.count
    }
    private var minSys: Int { readings.map(\.systolic).min() ?? 0 }
    private var maxSys: Int { readings.map(\.systolic).max() ?? 0 }

    private var trend: String {
        guard readings.count >= 4 else { return "→" }
        let half = readings.count / 2
        let recent = readings.suffix(half).map(\.systolic).reduce(0, +) / half
        let older  = readings.prefix(half).map(\.systolic).reduce(0, +) / half
        if recent < older - 2 { return "↓" }
        if recent > older + 2 { return "↑" }
        return "→"
    }

    var body: some View {
        HStack(spacing: 0) {
            StatCell(title: "Avg", value: "\(avgSys)/\(avgDia)", unit: "mmHg")
            Divider().frame(height: 36)
            StatCell(title: "Range", value: "\(minSys)–\(maxSys)", unit: "systolic")
            Divider().frame(height: 36)
            StatCell(title: "Trend", value: trend, unit: "systolic")
            Divider().frame(height: 36)
            StatCell(title: "Count", value: "\(readings.count)", unit: "readings")
        }
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct StatCell: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 2) {
            Text(title).font(.caption2).foregroundStyle(.secondary)
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .monospacedDigit()
            Text(unit).font(.caption2).foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - AM/PM Split

struct AMPMSplitCards: View {
    let readings: [BPReading]

    private var am: [BPReading] { readings.filter(\.isMorningReading) }
    private var pm: [BPReading] { readings.filter { !$0.isMorningReading } }

    var body: some View {
        if am.isEmpty && pm.isEmpty {
            EmptyView()
        } else {
            HStack(spacing: 12) {
                AMPMCard(label: "Morning", icon: "sunrise.fill",
                         color: .orange, readings: am)
                AMPMCard(label: "Evening", icon: "moon.stars.fill",
                         color: .indigo, readings: pm)
            }
        }
    }
}

struct AMPMCard: View {
    let label: String
    let icon: String
    let color: Color
    let readings: [BPReading]

    private var avg: (sys: Int, dia: Int)? {
        guard !readings.isEmpty else { return nil }
        return (readings.map(\.systolic).reduce(0,+) / readings.count,
                readings.map(\.diastolic).reduce(0,+) / readings.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon).foregroundStyle(color)
                Text(label).font(.subheadline).fontWeight(.medium)
            }
            if let a = avg {
                Text("\(a.sys)/\(a.dia)")
                    .font(.system(.title2, design: .rounded, weight: .bold)).monospacedDigit()
                Text("avg mmHg").font(.caption).foregroundStyle(.secondary)
            } else {
                Text("No data").font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
