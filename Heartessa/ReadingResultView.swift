import SwiftUI
import SwiftData

// MARK: - BP Result Screen (Screen 6)

struct ReadingResultView: View {
    let reading: BPReading
    let showSuccess: Bool
    var onDone: (() -> Void)? = nil      // pass from AddReadingView to close the sheet

    @Environment(\.dismiss)      private var dismiss
    @Environment(\.modelContext) private var context

    @State private var showDeleteAlert   = false
    @State private var successVisible    = false

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            ZStack(alignment: .top) {
                DS.Color.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    headerRow(w: w)
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            heroArea(w: w)
                            bottomContent(w: w)
                        }
                        .padding(.bottom, 32)
                    }
                }

                // Success banner
                if successVisible {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(DS.Color.catNormal)
                        Text("Reading saved")
                            .font(DS.Font.label)
                            .foregroundStyle(DS.Color.textPrimary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(DS.Color.card)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                    .padding(.top, 60)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .onAppear {
            if showSuccess {
                withAnimation(.spring(duration: 0.4)) { successVisible = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    withAnimation(.easeOut(duration: 0.3)) { successVisible = false }
                }
            }
        }
        .alert("Delete this reading?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteReading)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This reading will be permanently removed.")
        }
    }

    // MARK: - Header

    private func headerRow(w: CGFloat) -> some View {
        ZStack {
            Text("BP Results")
                .font(DS.Font.grotesk(18, weight: .medium))
                .foregroundStyle(DS.Color.textPrimary)

            HStack {
                Button { onDone != nil ? onDone!() : dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(DS.Color.textPrimary)
                        .frame(width: 36, height: 36)
                        .background(DS.Color.card)
                        .clipShape(Circle())
                }
                Spacer()
                Button { shareReading() } label: {
                    Image(systemName: "arrow.down.to.line")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(DS.Color.textPrimary)
                        .frame(width: 36, height: 36)
                        .background(DS.Color.card)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Hero (heart image + ECG line + floating card)

    private func heroArea(w: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            // Heart + ECG layer
            ZStack {
                ECGLine()
                    .stroke(categoryColor.opacity(0.55), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .frame(maxWidth: .infinity)
                    .frame(height: w * 0.55)
                    .padding(.horizontal, 20)

                Image("anatomical-heart")
                    .resizable()
                    .scaledToFit()
                    .frame(height: w * 0.55)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -10)
            }
            .frame(height: w * 0.55)
            .clipped()

            // Floating BP card
            floatingBPCard(w: w)
                .padding(.trailing, 20)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity)
    }

    private func floatingBPCard(w: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Blood Pressure")
                .font(DS.Font.mono(9))
                .foregroundStyle(DS.Color.textMuted)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(reading.systolic)")
                    .font(DS.Font.grotesk(40, weight: .light))
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
                Text("/")
                    .font(DS.Font.grotesk(20, weight: .light))
                    .foregroundStyle(DS.Color.textTertiary)
                Text("\(reading.diastolic)")
                    .font(DS.Font.grotesk(26, weight: .light))
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
            }

            HStack(spacing: 4) {
                Text("mmHg ·")
                    .font(DS.Font.mono(10))
                    .foregroundStyle(DS.Color.textMuted)
                Text(categoryShortLabel)
                    .font(DS.Font.mono(10))
                    .foregroundStyle(categoryColor)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(DS.Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.4), radius: 12, y: 4)
    }

    // MARK: - Metric grid + meta + delete

    private func bottomContent(w: CGFloat) -> some View {
        VStack(spacing: 16) {
            // 2×2 metric grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                metricCard(label: "Systolic",  value: "\(reading.systolic)", unit: "mmHg")
                metricCard(label: "Diastolic", value: "\(reading.diastolic)", unit: "mmHg")
                categoryCard
                metricCard(label: "Pulse",     value: "\(reading.pulse)", unit: "bpm")
            }

            // Meta line
            Text(metaLine)
                .font(DS.Font.mono(10))
                .foregroundStyle(DS.Color.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Delete button
            Button { showDeleteAlert = true } label: {
                Text("Delete Reading")
                    .font(DS.Font.label)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(hex: "#C0392B"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private func metricCard(label: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(DS.Font.mono(9))
                .foregroundStyle(DS.Color.textMuted)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(DS.Font.grotesk(28, weight: .light))
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
                Text(unit)
                    .font(DS.Font.mono(10))
                    .foregroundStyle(DS.Color.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(DS.Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var categoryCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("CATEGORY")
                .font(DS.Font.mono(9))
                .foregroundStyle(DS.Color.textMuted)
            Text(categoryShortLabel)
                .font(DS.Font.grotesk(20, weight: .medium))
                .foregroundStyle(categoryColor)
            Text(categoryRange)
                .font(DS.Font.mono(9))
                .foregroundStyle(DS.Color.textMuted)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(DS.Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Actions

    private func deleteReading() {
        context.delete(reading)
        onDone != nil ? onDone!() : dismiss()
    }

    private func shareReading() {
        let text = """
        Blood Pressure Reading — \(metaLine)
        \(reading.systolic)/\(reading.diastolic) mmHg · \(reading.pulse) bpm
        Category: \(categoryShortLabel)
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(av, animated: true)
        }
    }

    // MARK: - Category helpers

    private var categoryColor: Color {
        switch reading.category {
        case .normal:      DS.Color.catNormal
        case .elevated:    DS.Color.catElevated
        case .highStage1:  DS.Color.catStage1
        case .highStage2:  DS.Color.catStage2
        case .crisis:      DS.Color.catCrisis
        case .hypotension: DS.Color.catHypo
        case .ish:         DS.Color.catISH
        }
    }

    private var categoryShortLabel: String {
        switch reading.category {
        case .normal:      "Normal"
        case .elevated:    "Elevated"
        case .highStage1:  "Stage 1"
        case .highStage2:  "Stage 2"
        case .crisis:      "Crisis"
        case .hypotension: "Low BP"
        case .ish:         "ISH"
        }
    }

    private var categoryRange: String {
        switch reading.category {
        case .normal:      "< 120 systolic and < 80 diastolic"
        case .elevated:    "120–129 systolic, < 80 diastolic"
        case .highStage1:  "130–139 systolic or 80–89 diastolic"
        case .highStage2:  "≥ 140 systolic or ≥ 90 diastolic"
        case .crisis:      "≥ 180 systolic or ≥ 120 diastolic"
        case .hypotension: "< 90 systolic or < 60 diastolic"
        case .ish:         "≥ 140 systolic, diastolic < 80"
        }
    }

    private var metaLine: String {
        let d = reading.timestamp.formatted(.dateTime.month(.abbreviated).day())
        let t = reading.timestamp.formatted(date: .omitted, time: .shortened)
        return "\(d) · \(t)"
    }
}

// MARK: - ECG Line shape (use with .stroke() at call site)

struct ECGLine: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        let mid = h * 0.65
        var p = Path()

        p.move(to: CGPoint(x: 0, y: mid))
        p.addLine(to: CGPoint(x: w * 0.28, y: mid))

        // P wave
        p.addCurve(
            to:         CGPoint(x: w * 0.36, y: mid),
            control1:   CGPoint(x: w * 0.30, y: mid - h * 0.05),
            control2:   CGPoint(x: w * 0.34, y: mid - h * 0.05)
        )
        p.addLine(to: CGPoint(x: w * 0.41, y: mid))

        // QRS complex
        p.addLine(to: CGPoint(x: w * 0.44, y: mid + h * 0.04))   // Q
        p.addLine(to: CGPoint(x: w * 0.49, y: mid - h * 0.34))   // R
        p.addLine(to: CGPoint(x: w * 0.53, y: mid + h * 0.05))   // S

        // T wave
        p.addCurve(
            to:         CGPoint(x: w * 0.64, y: mid),
            control1:   CGPoint(x: w * 0.56, y: mid - h * 0.11),
            control2:   CGPoint(x: w * 0.62, y: mid - h * 0.11)
        )
        p.addLine(to: CGPoint(x: w, y: mid))

        return p
    }
}

