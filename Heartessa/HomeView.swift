import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \BPReading.timestamp, order: .reverse) private var readings: [BPReading]
    @State private var showingAddReading = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if readings.isEmpty {
                        EmptyHomeCard { showingAddReading = true }
                            .padding(.top, 48)
                    } else {
                        LatestReadingCard(reading: readings[0])

                        if let delta = InsightService.morningSurge(readings: Array(readings)) {
                            SurgeInsightCard(delta: delta)
                        }

                        if let delta = InsightService.weekDelta(readings: Array(readings)) {
                            WeekDeltaCard(delta: delta)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .navigationTitle("Heartessa")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAddReading = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddReading) {
                AddReadingView()
            }
        }
    }
}

// MARK: - Latest Reading Card

struct LatestReadingCard: View {
    let reading: BPReading

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Latest Reading")
                    .font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                Text(reading.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption).foregroundStyle(.tertiary)
            }

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(reading.systolic)/\(reading.diastolic)")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text("mmHg").font(.title3).foregroundStyle(.secondary)
                Spacer()
                CategoryBadge(reading: reading)
            }

            HStack(spacing: 16) {
                Label("\(reading.pulse) bpm", systemImage: "waveform.path.ecg")
                    .font(.subheadline).foregroundStyle(.secondary)
                if reading.arm != .unspecified {
                    Text(reading.arm.rawValue)
                        .font(.caption).padding(.horizontal, 6).padding(.vertical, 2)
                        .background(.quaternary, in: Capsule())
                }
                if reading.position != .unspecified {
                    Text(reading.position.rawValue)
                        .font(.caption).padding(.horizontal, 6).padding(.vertical, 2)
                        .background(.quaternary, in: Capsule())
                }
                Spacer()
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Insight Cards

struct SurgeInsightCard: View {
    let delta: Int

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sunrise.fill").font(.title2).foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text("Morning Surge Detected").font(.subheadline).fontWeight(.semibold)
                Text("Your morning reading is \(delta) mmHg higher than this evening")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.orange.opacity(0.3), lineWidth: 1))
    }
}

struct WeekDeltaCard: View {
    let delta: Int

    private var improved: Bool { delta < 0 }
    private var accent: Color { improved ? Color(hex: "#2D9D6E") : .red }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: improved ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                .font(.title2).foregroundStyle(accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("Week Over Week").font(.subheadline).fontWeight(.semibold)
                Text("Average is \(abs(delta)) mmHg \(improved ? "lower" : "higher") than last week \(improved ? "↓" : "↑")")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(accent.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(accent.opacity(0.3), lineWidth: 1))
    }
}

struct EmptyHomeCard: View {
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.clipboard")
                .font(.system(size: 60)).foregroundStyle(Color(hex: "#2D9D6E"))
            Text("No readings yet").font(.title2).fontWeight(.semibold)
            Text("Log your first blood pressure reading to get started.")
                .font(.body).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button(action: onAdd) {
                Label("Add Reading", systemImage: "plus")
                    .font(.headline)
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color(hex: "#2D9D6E"))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding(32).frame(maxWidth: .infinity)
    }
}
