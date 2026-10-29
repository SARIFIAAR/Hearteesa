import HealthKit
import Foundation

@MainActor
final class HealthKitService {
    static let shared = HealthKitService()
    private let store = HKHealthStore()
    private var authorized = false

    private init() {}

    private var shareTypes: Set<HKSampleType> {
        [HKQuantityType(.bloodPressureSystolic),
         HKQuantityType(.bloodPressureDiastolic),
         HKCorrelationType(.bloodPressure)]
    }

    private var readTypes: Set<HKObjectType> {
        [HKCorrelationType(.bloodPressure)]
    }

    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        do {
            try await store.requestAuthorization(toShare: shareTypes, read: readTypes)
            authorized = true
        } catch {}
    }

    func write(reading: BPReading) {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        Task { @MainActor in
            if !authorized { await requestAuthorization() }
            guard authorized else { return }

            let mmHg = HKUnit.millimeterOfMercury()
            let date = reading.timestamp
            let sysType = HKQuantityType(.bloodPressureSystolic)
            let diaType = HKQuantityType(.bloodPressureDiastolic)
            let bpType  = HKCorrelationType(.bloodPressure)

            let sys = HKQuantitySample(
                type: sysType,
                quantity: HKQuantity(unit: mmHg, doubleValue: Double(reading.systolic)),
                start: date, end: date)
            let dia = HKQuantitySample(
                type: diaType,
                quantity: HKQuantity(unit: mmHg, doubleValue: Double(reading.diastolic)),
                start: date, end: date)
            let correlation = HKCorrelation(
                type: bpType, start: date, end: date, objects: [sys, dia])

            do { try await store.save(correlation) } catch {}
        }
    }
}
