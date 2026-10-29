import Foundation

enum InsightService {
    static let surgeThreshold = 15

    static func morningSurge(readings: [BPReading]) -> Int? {
        let cal = Calendar.current
        let byDay = Dictionary(grouping: readings) { cal.startOfDay(for: $0.timestamp) }
        for day in byDay.keys.sorted(by: >).prefix(3) {
            guard let dayReadings = byDay[day] else { continue }
            let am = dayReadings.filter { $0.isMorningReading }
            let pm = dayReadings.filter { !$0.isMorningReading }
            guard !am.isEmpty, !pm.isEmpty else { continue }
            let amAvg = am.map(\.systolic).reduce(0, +) / am.count
            let pmAvg = pm.map(\.systolic).reduce(0, +) / pm.count
            let delta = amAvg - pmAvg
            if delta >= surgeThreshold { return delta }
        }
        return nil
    }

    static func weekDelta(readings: [BPReading]) -> Int? {
        let cal = Calendar.current
        guard
            let thisWeekStart = cal.date(
                from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())),
            let lastWeekStart = cal.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart)
        else { return nil }

        let thisWeek = readings.filter { $0.timestamp >= thisWeekStart }
        let lastWeek = readings.filter {
            $0.timestamp >= lastWeekStart && $0.timestamp < thisWeekStart
        }
        guard thisWeek.count >= 3, lastWeek.count >= 3 else { return nil }

        let thisAvg = thisWeek.map(\.systolic).reduce(0, +) / thisWeek.count
        let lastAvg = lastWeek.map(\.systolic).reduce(0, +) / lastWeek.count
        return thisAvg - lastAvg
    }
}
