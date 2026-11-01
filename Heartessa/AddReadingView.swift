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

    @State private var showCameraHR  = false
    @State private var savedReading: BPReading?

    @FocusState private var focus: Field?
    enum Field { case systolic, diastolic, pulse }

    private var systolicVal: Int? { Int(systolicText) }
    private var diastolicVal: Int? { Int(diastolicText) }
    private var pulseVal: Int? {
        if pulseText.isEmpty { return 70 }
        guard let p = Int(pulseText), (30...220).contains(p) else { return nil }
        return p
    }

    private var canSave: Bool {
        guard let s = systolicVal, let d = diastolicVal, pulseVal != nil else { return false }
        return (60...250).contains(s) && (40...160).contains(d)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Cuff instruction
                    HStack(spacing: 10) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 13))
                            .foregroundStyle(DS.Color.textSecondary)
                        Text("Sit quietly for 5 minutes before measuring. Rest your arm at heart level.")
                            .font(DS.Font.micro)
                            .foregroundStyle(DS.Color.textSecondary)
                    }
                    .padding(12)
                    .background(DS.Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    // Big number inputs
                    HStack(spacing: 12) {
                        BPNumberField(
                            label: "SYSTOLIC",
                            placeholder: "120",
                            text: $systolicText,
                            focus: $focus,
                            field: .systolic,
                            valid: systolicVal.map { (60...250).contains($0) } ?? true
                        )

                        Text("/")
                            .font(DS.Font.heroSub)
                            .foregroundStyle(DS.Color.textTertiary)
                            .padding(.top, 28)

                        BPNumberField(
                            label: "DIASTOLIC",
                            placeholder: "80",
                            text: $diastolicText,
                            focus: $focus,
                            field: .diastolic,
                            valid: diastolicVal.map { (40...160).contains($0) } ?? true
                        )
                    }

                    // Pulse
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PULSE")
                            .font(DS.Font.mono(10))
                            .foregroundStyle(DS.Color.textMuted)
                        HStack {
                            TextField("70", text: $pulseText)
                                .font(DS.Font.grotesk(28, weight: .light))
                                .foregroundStyle(DS.Color.textPrimary)
                                .keyboardType(.numberPad)
                                .focused($focus, equals: .pulse)
                            Text("bpm")
                                .font(DS.Font.mono(13))
                                .foregroundStyle(DS.Color.textMuted)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(DS.Color.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button {
                            focus = nil
                            showCameraHR = true
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 11))
                                Text("Use camera to measure pulse")
                                    .font(DS.Font.mono(11))
                            }
                            .foregroundStyle(DS.Color.red)
                        }
                        .padding(.top, 2)
                    }

                    // Live category preview
                    if let s = systolicVal, let d = diastolicVal,
                       (60...250).contains(s), (40...160).contains(d) {
                        HStack {
                            Text("Category")
                                .font(DS.Font.caption)
                                .foregroundStyle(DS.Color.textSecondary)
                            Spacer()
                            AnyBPBadge(systolic: s, diastolic: d)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(DS.Color.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Arm
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ARM")
                            .font(DS.Font.mono(10))
                            .foregroundStyle(DS.Color.textMuted)
                        HStack(spacing: 8) {
                            ForEach(Arm.allCases, id: \.self) { a in
                                SegmentChip(label: a.rawValue, selected: arm == a) { arm = a }
                            }
                        }
                    }

                    // Position
                    VStack(alignment: .leading, spacing: 8) {
                        Text("POSITION")
                            .font(DS.Font.mono(10))
                            .foregroundStyle(DS.Color.textMuted)
                        HStack(spacing: 8) {
                            ForEach(Position.allCases, id: \.self) { p in
                                SegmentChip(label: p.rawValue, selected: position == p) { position = p }
                            }
                        }
                    }

                    // Date & time
                    VStack(alignment: .leading, spacing: 8) {
                        Text("DATE & TIME")
                            .font(DS.Font.mono(10))
                            .foregroundStyle(DS.Color.textMuted)
                        DatePicker("", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .colorScheme(.dark)
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES (OPTIONAL)")
                            .font(DS.Font.mono(10))
                            .foregroundStyle(DS.Color.textMuted)
                        TextField("Any context worth noting...", text: $notes, axis: .vertical)
                            .font(DS.Font.caption)
                            .foregroundStyle(DS.Color.textPrimary)
                            .lineLimit(3...5)
                            .padding(14)
                            .background(DS.Color.card)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Save button
                    PrimaryButton(title: "Save Reading", action: save)
                        .disabled(!canSave)
                        .opacity(canSave ? 1 : 0.4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .background(DS.Color.background.ignoresSafeArea())
            .navigationTitle("Log Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Done") { focus = nil }
                }
            }
            .preferredColorScheme(.dark)
            .navigationDestination(item: $savedReading) { reading in
                ReadingResultView(reading: reading, showSuccess: true, onDone: { dismiss() })
            }
            .sheet(isPresented: $showCameraHR) {
                CameraHRView { bpm in
                    pulseText = "\(bpm)"
                }
            }
        }
    }

    private func save() {
        guard let s = systolicVal, let d = diastolicVal else { return }
        let reading = BPReading(
            systolic: s, diastolic: d,
            pulse: pulseVal ?? 70,
            timestamp: timestamp,
            arm: arm, position: position,
            notes: notes
        )
        context.insert(reading)
        HealthKitService.shared.write(reading: reading)

        // Push to Watch (App Group + applicationContext) — no-op if Watch not paired.
        WatchConnectivityService.shared.pushLastReading(BPReadingDTO(from: reading))

        // Cloud sync — fire-and-forget. Fails silently for free users.
        Task {
            await FirestoreService.shared.syncReading(reading)
        }

        savedReading = reading
    }
}

// MARK: - BP Number Field

struct BPNumberField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var focus: FocusState<AddReadingView.Field?>.Binding
    let field: AddReadingView.Field
    let valid: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(DS.Font.mono(10))
                .foregroundStyle(DS.Color.textMuted)
            TextField(placeholder, text: $text)
                .font(DS.Font.grotesk(52, weight: .light))
                .foregroundStyle(valid ? DS.Color.textPrimary : DS.Color.red)
                .keyboardType(.numberPad)
                .focused(focus, equals: field)
                .multilineTextAlignment(.center)
                .frame(height: 80)
                .background(DS.Color.card)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Segment Chip

struct SegmentChip: View {
    let label: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(DS.Font.caption)
                .foregroundStyle(selected ? DS.Color.textPrimary : DS.Color.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selected ? DS.Color.red : DS.Color.card)
                .clipShape(Capsule())
        }
    }
}
