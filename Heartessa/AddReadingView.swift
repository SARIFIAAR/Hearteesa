import SwiftUI
import SwiftData

struct AddReadingView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var systolicText = ""
    @State private var diastolicText = ""
    @State private var pulseText = ""
    @State private var arm: Arm = .unspecified
    @State private var position: Position = .unspecified
    @State private var notes = ""
    @State private var timestamp = Date()

    @State private var systolicError: String?
    @State private var diastolicError: String?
    @State private var pulseError: String?

    @FocusState private var focus: EntryField?
    enum EntryField { case systolic, diastolic, pulse }

    private var systolicVal: Int? { Int(systolicText) }
    private var diastolicVal: Int? { Int(diastolicText) }

    private var canSave: Bool {
        guard let s = systolicVal, let d = diastolicVal else { return false }
        return (60...250).contains(s) && (40...160).contains(d) &&
               systolicError == nil && diastolicError == nil && pulseError == nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(alignment: .top, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Systolic").font(.caption).foregroundStyle(.secondary)
                            TextField("120", text: $systolicText)
                                .keyboardType(.numberPad)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .focused($focus, equals: .systolic)
                                .onChange(of: systolicText) { _, _ in validateSystolic() }
                            if let e = systolicError {
                                Text(e).font(.caption2).foregroundStyle(.red)
                            }
                        }
                        Text("/")
                            .font(.system(size: 32, weight: .light))
                            .foregroundStyle(.secondary)
                            .padding(.top, 20).padding(.horizontal, 8)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Diastolic").font(.caption).foregroundStyle(.secondary)
                            TextField("80", text: $diastolicText)
                                .keyboardType(.numberPad)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .focused($focus, equals: .diastolic)
                                .onChange(of: diastolicText) { _, _ in validateDiastolic() }
                            if let e = diastolicError {
                                Text(e).font(.caption2).foregroundStyle(.red)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                } header: { Text("Blood Pressure (mmHg)") }

                Section("Pulse (bpm)") {
                    TextField("70", text: $pulseText)
                        .keyboardType(.numberPad)
                        .focused($focus, equals: .pulse)
                        .onChange(of: pulseText) { _, _ in validatePulse() }
                    if let e = pulseError {
                        Text(e).font(.caption2).foregroundStyle(.red)
                    }
                }

                Section("Details") {
                    Picker("Arm", selection: $arm) {
                        ForEach(Arm.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }.pickerStyle(.segmented)

                    Picker("Position", selection: $position) {
                        ForEach(Position.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }.pickerStyle(.segmented)

                    DatePicker("Date & Time", selection: $timestamp,
                               displayedComponents: [.date, .hourAndMinute])
                }

                Section("Notes") {
                    TextField("Optional", text: $notes, axis: .vertical).lineLimit(3...6)
                }

                if let s = systolicVal, let d = diastolicVal,
                   (60...250).contains(s), (40...160).contains(d) {
                    Section {
                        HStack {
                            Text("Category")
                            Spacer()
                            CategoryBadge(systolic: s, diastolic: d)
                        }
                    }
                }
            }
            .navigationTitle("Add Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save).fontWeight(.semibold).disabled(!canSave)
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Done") { focus = nil }
                }
            }
        }
    }

    private func validateSystolic() {
        guard !systolicText.isEmpty else { systolicError = nil; return }
        systolicError = Int(systolicText).flatMap { (60...250).contains($0) ? nil : "Must be 60–250" } ?? "Must be 60–250"
    }

    private func validateDiastolic() {
        guard !diastolicText.isEmpty else { diastolicError = nil; return }
        diastolicError = Int(diastolicText).flatMap { (40...160).contains($0) ? nil : "Must be 40–160" } ?? "Must be 40–160"
    }

    private func validatePulse() {
        guard !pulseText.isEmpty else { pulseError = nil; return }
        pulseError = Int(pulseText).flatMap { (30...220).contains($0) ? nil : "Must be 30–220" } ?? "Must be 30–220"
    }

    private func save() {
        guard let s = systolicVal, let d = diastolicVal else { return }
        let reading = BPReading(
            systolic: s, diastolic: d,
            pulse: Int(pulseText) ?? 70,
            timestamp: timestamp,
            arm: arm, position: position,
            notes: notes
        )
        context.insert(reading)
        HealthKitService.shared.write(reading: reading)
        dismiss()
    }
}
