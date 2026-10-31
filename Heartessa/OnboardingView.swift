import SwiftUI
import UserNotifications
import UIKit

// MARK: - 12-Screen Onboarding State

private struct OnboardingAnswers {
    var lastChecked: String?
    var goal: String?
    var source: String?
    var routine: String?
    var reminderTime: Date = {
        var c = Calendar.current.dateComponents([.hour, .minute], from: .now)
        c.hour = 8; c.minute = 0
        return Calendar.current.date(from: c) ?? .now
    }()
    var premiumSelected = false
}

struct OnboardingView: View {
    @AppStorage("heartessa.hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var screen = 0
    @State private var answers = OnboardingAnswers()
    @State private var transitioning = false

    private let total = 12

    var body: some View {
        ZStack(alignment: .top) {
            DS.Color.background.ignoresSafeArea()

            // Screen content
            Group {
                switch screen {
                case 0:  S01_Quiet(answers: $answers,    done: next, skip: skip)
                case 1:  S02_Last(answers: $answers,     done: next)
                case 2:  S03_Silent(answers: $answers,   done: next)
                case 3:  S04_StressDay(answers: $answers,done: next)
                case 4:  S05_Pattern(answers: $answers,  done: next)
                case 5:  S06_Goal(answers: $answers,     done: next)
                case 6:  S07_Premium(answers: $answers,  done: next, skip: { answers.premiumSelected = false; next() })
                case 7:  S08_Source(answers: $answers,   done: next)
                case 8:  S09_Routine(answers: $answers,  done: next)
                case 9:  S10_Health(answers: $answers,   done: next, skip: next)
                case 10: S11_Reminder(answers: $answers, done: scheduleAndNext, skip: next)
                default: S12_Begin(onLog: finish, onExplore: finish)
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal:   .move(edge: .leading).combined(with: .opacity)
            ))
            .id(screen)

            // Top chrome
            VStack {
                HStack(spacing: 12) {
                    Button {
                        if screen > 0 { withAnimation(.spring(duration: 0.3)) { screen -= 1 } }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16))
                            .foregroundStyle(screen == 0 ? .clear : DS.Color.textSecondary)
                            .frame(width: 32, height: 32)
                    }
                    .disabled(screen == 0)

                    // Progress bar — active = wider red pill, inactive = short muted dash
                    HStack(spacing: 3) {
                        ForEach(0..<total, id: \.self) { i in
                            Capsule()
                                .fill(i == screen ? DS.Color.red : Color(hex: "#deded7").opacity(0.22))
                                .frame(width: i == screen ? 22 : 18, height: i == screen ? 4 : 3)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: screen)

                    Button("Skip setup") {
                        skip()
                    }
                    .font(DS.Font.micro)
                    .foregroundStyle(DS.Color.textMuted)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }

    private func next() {
        guard !transitioning else { return }
        transitioning = true
        withAnimation(.spring(duration: 0.3)) {
            if screen < total - 1 { screen += 1 } else { finish() }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { transitioning = false }
    }

    private func skip() {
        hasSeenOnboarding = true
    }

    private func finish() {
        hasSeenOnboarding = true
    }

    private func scheduleAndNext() {
        Task {
            await ReminderService.requestPermission()
            if answers.routine != "I'll decide later" {
                if answers.routine == "Evening" {
                    await ReminderService.scheduleEvening()
                } else {
                    await ReminderService.scheduleMorning()
                }
            }
        }
        next()
    }
}

// MARK: - Screen Shell

private struct ScreenShell<Content: View>: View {
    let chapter: String
    let title: String
    let subtitle: String
    let detail: String?
    let cta: String
    let secondary: String?
    let canContinue: Bool
    let onContinue: () -> Void
    let onSecondary: (() -> Void)?
    @ViewBuilder let content: () -> Content

    init(chapter: String, title: String, subtitle: String, detail: String? = nil,
         cta: String, secondary: String? = nil, canContinue: Bool = true,
         onContinue: @escaping () -> Void, onSecondary: (() -> Void)? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.chapter = chapter; self.title = title; self.subtitle = subtitle
        self.detail = detail; self.cta = cta; self.secondary = secondary
        self.canContinue = canContinue; self.onContinue = onContinue
        self.onSecondary = onSecondary; self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Chapter label
                    Text(chapter.uppercased())
                        .font(DS.Font.mono(10))
                        .foregroundStyle(DS.Color.red.opacity(0.7))
                        .padding(.top, 80)
                        .padding(.bottom, 16)

                    // Heading
                    Text(title)
                        .font(DS.Font.grotesk(28, weight: .light))
                        .foregroundStyle(DS.Color.textPrimary)
                        .padding(.bottom, 12)

                    // Subtitle
                    Text(subtitle)
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                        .lineSpacing(4)
                        .padding(.bottom, 24)

                    // Screen-specific content
                    content()

                    // Detail footnote
                    if let d = detail {
                        Text(d)
                            .font(DS.Font.mono(10))
                            .foregroundStyle(DS.Color.textMuted)
                            .padding(.top, 16)
                            .lineSpacing(3)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 180)
            }

            // Fixed bottom actions
            VStack(spacing: 8) {
                PrimaryButton(title: cta + " →", action: onContinue)
                    .disabled(!canContinue)
                    .opacity(canContinue ? 1 : 0.45)

                if let sec = secondary, let action = onSecondary {
                    Button(sec) { action() }
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                        .frame(height: 36)
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 40)
            .background(
                LinearGradient(colors: [DS.Color.background.opacity(0), DS.Color.background, DS.Color.background],
                               startPoint: .top, endPoint: .bottom)
            )
        }
    }
}

// MARK: - Choice Card

private struct ChoiceCard: View {
    let text: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(DS.Font.label)
                    .foregroundStyle(DS.Color.textPrimary)
                    .multilineTextAlignment(.leading)
                Spacer()
                ZStack {
                    Circle()
                        .stroke(selected ? DS.Color.red : DS.Color.separator, lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                    if selected {
                        Circle()
                            .fill(DS.Color.red)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(selected ? DS.Color.red.opacity(0.12) : DS.Color.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selected ? DS.Color.red.opacity(0.4) : .clear, lineWidth: 1)
            )
        }
    }
}

// MARK: - Screen 01: Quiet (awareness)
// Layout mirrors the HTML reference exactly:
//   • step-chapter at top of scroller
//   • onboard-art absolutely behind everything (top: 9cqw, bleeds ±7cqw, height: 100cqw)
//   • h2 with padding-top: 63cqw pushes title into the art's lower half
//   • flow-bottom button pinned to bottom

private struct S01_Quiet: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    let skip: () -> Void

    @State private var heartScale: CGFloat = 1.0
    @State private var beatTimer: Timer?

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width

            ZStack {
                // ── Wallpaper ──────────────────────────────────────────────
                Color(hex: "#0a100e").ignoresSafeArea()
                RadialGradient(colors: [Color(hex: "#b42734").opacity(0.23), .clear],
                               center: .init(x: -0.10, y: 0.12),
                               startRadius: 0, endRadius: w * 0.58).ignoresSafeArea()
                RadialGradient(colors: [Color(hex: "#759d92").opacity(0.20), .clear],
                               center: .init(x: 1.10, y: 0.70),
                               startRadius: 0, endRadius: w * 0.55).ignoresSafeArea()
                RadialGradient(colors: [Color(hex: "#b4714d").opacity(0.14), .clear],
                               center: .init(x: 0.45, y: 1.05),
                               startRadius: 0, endRadius: w * 0.50).ignoresSafeArea()

                // ── Heart art layer (z behind text) ────────────────────────
                // CSS: inset: 9cqw -7cqw auto; height: 100cqw; img: height:100%, width:78cqw, object-fit:contain
                let artTop = w * 0.38   // 29cqw scroller top + 9cqw art offset
                let artH   = w * 1.0    // 100cqw
                let artW   = w * 1.14   // bleeds 7cqw each side

                ZStack {
                    // Heart: constrain by height so portrait image (1024×1536) never overflows vertically
                    Image("anatomical-heart")
                        .resizable()
                        .scaledToFit()
                        .frame(height: artH)   // height = binding dimension → renders ~262×393pt
                        .scaleEffect(heartScale, anchor: .init(x: 0.5, y: 0.60))

                    // ECG trace — center at 51.7% of art height (canvas y=310/600)
                    ECGTraceView(width: artW)
                        .frame(width: artW, height: artH * 0.30)
                        .offset(y: artH * 0.017)
                        .allowsHitTesting(false)
                }
                .frame(width: artW, height: artH)
                .clipped()             // hard clip: nothing escapes the art container
                .opacity(0.85)
                .overlay(alignment: .bottom) {
                    LinearGradient(stops: [
                        .init(color: .clear,                               location: 0.00),
                        .init(color: Color(hex: "#080909").opacity(0.26),  location: 0.42),
                        .init(color: Color(hex: "#080909").opacity(0.90),  location: 0.80),
                        .init(color: Color(hex: "#080909"),                location: 1.00)
                    ], startPoint: .top, endPoint: .bottom)
                    .frame(height: artH)
                }
                .position(x: w * 0.5, y: artTop + artH * 0.5)

                // Dark strip above the art so "THE UNKNOWN" always sits on clean dark
                Color(hex: "#0a100e")
                    .frame(height: artTop)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)

                // ── Screen-level dark overlay: ensures text area is always solid dark ──
                // Covers from mid-screen to bottom so body/detail text sits on pure #080909
                LinearGradient(stops: [
                    .init(color: .clear,                              location: 0.38),
                    .init(color: Color(hex: "#080909").opacity(0.50), location: 0.52),
                    .init(color: Color(hex: "#080909"),               location: 0.65)
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .allowsHitTesting(false)

                // ── Text content layer ─────────────────────────────────────
                VStack(alignment: .leading, spacing: 0) {
                    Text("THE UNKNOWN")
                        .font(DS.Font.mono(w * 0.025))
                        .foregroundStyle(Color(hex: "#d29c93"))
                        .tracking(w * 0.006)

                    Color.clear.frame(height: w * 0.58)   // padding-top: 63cqw for h2

                    // Title: use system font at Black weight — matches SF Pro Display in reference
                    Text("What could you be missing?")
                        .font(.system(size: w * 0.092, weight: .black, design: .default))
                        .tracking(-(w * 0.004))
                        .lineSpacing(2)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.70), radius: 20, y: 2)
                        .padding(.bottom, w * 0.035)

                    Text("Feeling fine doesn't always tell you what your blood pressure is doing.")
                        .font(DS.Font.grotesk(w * 0.035))
                        .foregroundStyle(Color(hex: "#deded7"))
                        .lineSpacing(5)
                        .shadow(color: .black.opacity(0.60), radius: 10, y: 1)
                        .padding(.bottom, w * 0.025)

                    Text("Replace the unknown with a clearer picture.")
                        .font(DS.Font.mono(w * 0.028))
                        .foregroundStyle(Color(hex: "#deded7").opacity(0.75))
                        .shadow(color: .black.opacity(0.60), radius: 10, y: 1)
                }
                .padding(.top, w * 0.30)
                .padding(.horizontal, w * 0.07)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                // ── flow-bottom: CTA pinned to bottom (8cqw) ──────────────
                VStack(spacing: 0) {
                    Spacer()

                    Button(action: done) {
                        HStack {
                            Spacer()
                            Text("Find out why →")
                                .font(DS.Font.grotesk(w * 0.036, weight: .medium))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .frame(minHeight: w * 0.13)
                        .background(LinearGradient(
                            colors: [Color(hex: "#29392b"), Color(hex: "#101c14")],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .overlay(RoundedRectangle(cornerRadius: w * 0.08)
                            .stroke(Color.white.opacity(0.33), lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: w * 0.08))
                        .shadow(color: Color(hex: "#172c25").opacity(0.14), radius: 15, y: 5)
                    }

                }
                .padding(.horizontal, w * 0.07)
                .padding(.bottom, 34)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear { startBeat() }
        .onDisappear { beatTimer?.invalidate() }
    }

    // cardiac-beat CSS keyframes (1.5 s, double pulse)
    private func startBeat() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()

        func cycle() {
            withAnimation(.easeInOut(duration: 0.135)) { heartScale = 1.035 }
            impact.impactOccurred(intensity: 0.6)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.135) {
                withAnimation(.easeInOut(duration: 0.12)) { heartScale = 1.006 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                withAnimation(.easeInOut(duration: 0.135)) { heartScale = 1.022 }
                impact.impactOccurred(intensity: 0.4)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.375) {
                withAnimation(.easeInOut(duration: 0.135)) { heartScale = 1.0 }
            }
        }

        cycle()
        beatTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in cycle() }
    }
}

// MARK: - ECG Trace Canvas

private struct ECGTraceView: View {
    let width: CGFloat
    @State private var phase: Double = 0

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let t = phase
                let h = size.height
                let cycleWidth = size.width
                let traceAge = t.truncatingRemainder(dividingBy: 1.5)
                let head = min(1.0, traceAge / 0.98)

                // Draw trace left-to-right
                var prevX: CGFloat = 0
                var prevY: CGFloat = h * 0.5 + waveform(0) * h * 0.45

                var x: CGFloat = 3
                while x <= head * cycleWidth {
                    let alpha = max(0, 1.0 - (traceAge - x / cycleWidth * 0.98) / 1.1)
                    let y = h * 0.5 + waveform(x / cycleWidth) * h * 0.45

                    var path = Path()
                    path.move(to: CGPoint(x: prevX, y: prevY))
                    path.addLine(to: CGPoint(x: x, y: y))

                    ctx.stroke(
                        path,
                        with: .color(Color(red: 1, green: 91/255, blue: 104/255).opacity(alpha)),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    prevX = x; prevY = y
                    x += 3
                }
            }
            .onChange(of: timeline.date) { _, _ in
                phase += 1.0 / 60.0
            }
        }
        .allowsHitTesting(false)
    }

    // Mirrors JS waveform() — piecewise linear ECG shape
    private func waveform(_ x: CGFloat) -> CGFloat {
        let phase = (x * 4 + 0.12).truncatingRemainder(dividingBy: 1.0)
        let pts: [(CGFloat, CGFloat)] = [
            (0,0),(0.12,0),(0.16,-0.055),(0.19,0.14),(0.22,-0.08),
            (0.255,-0.57),(0.295,0.43),(0.33,0),(0.4,0),(0.45,-0.21),
            (0.49,-0.04),(0.54,0),(1,0)
        ]
        for i in 1..<pts.count {
            if phase <= pts[i].0 {
                let ax = pts[i-1].0, ay = pts[i-1].1
                let bx = pts[i].0,   by = pts[i].1
                return ay + (by - ay) * (phase - ax) / (bx - ax)
            }
        }
        return 0
    }
}

// MARK: - Screen 02: Last check

private struct S02_Last: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    private let choices = ["Within the last week", "Within the last month", "It's been a while", "I don't remember"]

    var body: some View {
        ScreenShell(
            chapter: "Your starting point",
            title: "How long has it been since you knew?",
            subtitle: "Think about the last time you checked your blood pressure.",
            detail: "No judgment. Your next reading can be a fresh start.",
            cta: "Continue",
            canContinue: true,
            onContinue: done
        ) {
            VStack(spacing: 8) {
                ForEach(choices, id: \.self) { c in
                    ChoiceCard(text: c, selected: answers.lastChecked == c) {
                        answers.lastChecked = c
                    }
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 03: Silent risk

private struct S03_Silent: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void

    var body: some View {
        ScreenShell(
            chapter: "Why it matters",
            title: "You may not feel a change.",
            subtitle: "High blood pressure usually has no warning signs. Measuring helps you know where you stand.",
            detail: "A reading gives you information that feelings alone can't.",
            cta: "Stop guessing",
            onContinue: done
        ) {
            VStack(spacing: 12) {
                ForEach([
                    ("eye.slash", "Often silent", "No noticeable symptoms in most cases"),
                    ("chart.line.uptrend.xyaxis", "Can change daily", "Varies with stress, sleep, and activity"),
                    ("doc.text.magnifyingglass", "Worth knowing", "A record helps you and your clinician")
                ], id: \.0) { icon, label, sub in
                    HStack(spacing: 14) {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundStyle(DS.Color.red)
                            .frame(width: 36, height: 36)
                            .background(DS.Color.card)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 2) {
                            Text(label).font(DS.Font.label).foregroundStyle(DS.Color.textPrimary)
                            Text(sub).font(DS.Font.micro).foregroundStyle(DS.Color.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(DS.Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 04: Stress day (context intro)

private struct S04_StressDay: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void

    var body: some View {
        ScreenShell(
            chapter: "Your day, in context",
            title: "Some days ask more of you.",
            subtitle: "Stress can temporarily raise heart rate and blood pressure. Keep a note of how you felt alongside your readings.",
            detail: "Feelings are self-reported, not detected. Timing alone does not prove cause.",
            cta: "See the bigger picture",
            onContinue: done
        ) {
            VStack(spacing: 8) {
                ForEach([
                    ("08:00", "118/76", "Normal", "Before the day begins"),
                    ("14:00", "132/84", "High Stage 1", "Busy afternoon"),
                    ("20:00", "122/78", "Normal", "Winding down")
                ], id: \.0) { time, bp, cat, note in
                    HStack(spacing: 12) {
                        Text(time)
                            .font(DS.Font.mono(11))
                            .foregroundStyle(DS.Color.textMuted)
                            .frame(width: 44, alignment: .leading)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(bp).font(DS.Font.grotesk(16, weight: .regular))
                                .foregroundStyle(DS.Color.textPrimary)
                            Text(note).font(DS.Font.micro).foregroundStyle(DS.Color.textMuted)
                        }
                        Spacer()
                        Text(cat)
                            .font(DS.Font.micro)
                            .foregroundStyle(cat == "Normal" ? DS.Color.catNormal : DS.Color.catStage1)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background((cat == "Normal" ? DS.Color.catNormal : DS.Color.catStage1).opacity(0.15))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(DS.Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 05: Pattern preview

private struct S05_Pattern: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void

    var body: some View {
        ScreenShell(
            chapter: "Preview your record",
            title: "See what a clearer picture looks like.",
            subtitle: "One reading, saved with its time and context. A record you can return to and share.",
            detail: "Example dashboard · Basic charts and PDF export stay free.",
            cta: "Show me the bigger picture",
            onContinue: done
        ) {
            VStack(alignment: .leading, spacing: 8) {
                // Mock reading card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("EXAMPLE READING")
                            .font(DS.Font.mono(9))
                            .foregroundStyle(DS.Color.textMuted)
                        Spacer()
                        AnyBPBadge(systolic: 124, diastolic: 82)
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("124")
                            .font(DS.Font.grotesk(44, weight: .light))
                            .foregroundStyle(DS.Color.textPrimary)
                        Text("/82")
                            .font(DS.Font.grotesk(28, weight: .light))
                            .foregroundStyle(DS.Color.textSecondary)
                        Spacer()
                        Text("mmHg")
                            .font(DS.Font.mono(11))
                            .foregroundStyle(DS.Color.textMuted)
                    }
                    HStack(spacing: 6) {
                        Chip("Morning"); Chip("Left arm"); Chip("Sitting")
                    }
                }
                .padding(16)
                .background(DS.Color.card)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // PDF export row
                HStack {
                    Image(systemName: "doc.richtext")
                        .foregroundStyle(DS.Color.red)
                    Text("PDF report")
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textPrimary)
                    Spacer()
                    Text("Always free")
                        .font(DS.Font.micro)
                        .foregroundStyle(DS.Color.catNormal)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(DS.Color.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 06: Goal

private struct S06_Goal: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    private let choices = [
        "Understand my usual readings",
        "Follow a plan from my clinician",
        "Build a steady routine",
        "Keep an eye on changes"
    ]

    var body: some View {
        ScreenShell(
            chapter: "Make it yours",
            title: "What would you rather stop wondering about?",
            subtitle: "Choose the question you want a clearer answer to.",
            detail: "Your goal shapes the app, not a diagnosis.",
            cta: "That matters to me",
            canContinue: true,
            onContinue: done
        ) {
            VStack(spacing: 8) {
                ForEach(choices, id: \.self) { c in
                    ChoiceCard(text: c, selected: answers.goal == c) { answers.goal = c }
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 07: Premium (optional, with free path)

private struct S07_Premium: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    let skip: () -> Void
    @State private var selected = ""

    var body: some View {
        ScreenShell(
            chapter: "Go deeper, when you're ready",
            title: "Make more sense of the readings you keep.",
            subtitle: "Explore your recorded patterns, keep your records together, and organize care around your routine.",
            detail: "Auto-renewing. $1.99/month or $12.99/year. Basic logging, charts, Apple Health sync, reminders, and PDF export stay free.",
            cta: "Start Premium",
            secondary: "Continue free",
            canContinue: !selected.isEmpty,
            onContinue: {
                answers.premiumSelected = true
                done()
            },
            onSecondary: skip
        ) {
            VStack(spacing: 10) {
                ForEach([
                    ("01", "Advanced analytics", "Explore more of your recorded patterns."),
                    ("02", "Apple Watch & cloud sync", "More ways to keep your readings together."),
                    ("03", "Multiple profiles", "Keep your records organized around your needs.")
                ], id: \.0) { num, label, sub in
                    HStack(spacing: 14) {
                        Text(num)
                            .font(DS.Font.grotesk(22, weight: .light))
                            .foregroundStyle(DS.Color.red.opacity(0.7))
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(label).font(DS.Font.label).foregroundStyle(DS.Color.textPrimary)
                            Text(sub).font(DS.Font.micro).foregroundStyle(DS.Color.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(DS.Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Plan choices
                VStack(spacing: 6) {
                    ForEach(["monthly", "yearly"], id: \.self) { plan in
                        Button { selected = plan } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(plan == "monthly" ? "Monthly" : "Yearly")
                                        .font(DS.Font.label).foregroundStyle(DS.Color.textPrimary)
                                    Text(plan == "monthly" ? "Billed monthly" : "Billed $12.99 once a year")
                                        .font(DS.Font.micro).foregroundStyle(DS.Color.textSecondary)
                                }
                                Spacer()
                                Text(plan == "monthly" ? "$1.99" : "$12.99")
                                    .font(DS.Font.grotesk(20, weight: .light))
                                    .foregroundStyle(DS.Color.textPrimary)
                                ZStack {
                                    Circle().stroke(selected == plan ? DS.Color.red : DS.Color.separator, lineWidth: 1.5)
                                        .frame(width: 20, height: 20)
                                    if selected == plan {
                                        Circle().fill(DS.Color.red).frame(width: 10, height: 10)
                                    }
                                }
                            }
                            .padding(14)
                            .background(selected == plan ? DS.Color.red.opacity(0.1) : DS.Color.card)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(selected == plan ? DS.Color.red.opacity(0.4) : .clear, lineWidth: 1))
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 08: Source

private struct S08_Source: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    private let choices = ["I have a blood pressure cuff", "I have readings in Apple Health", "I'm just exploring"]

    var body: some View {
        ScreenShell(
            chapter: "Your readings",
            title: "How will you bring your readings in?",
            subtitle: "Heartessa keeps your numbers together. Blood pressure readings come from a monitor, not your phone or Apple Watch.",
            cta: "Continue",
            onContinue: done
        ) {
            VStack(spacing: 8) {
                ForEach(choices, id: \.self) { c in
                    ChoiceCard(text: c, selected: answers.source == c) { answers.source = c }
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 09: Routine

private struct S09_Routine: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    private let choices = ["Morning", "Evening", "I'll decide later"]

    var body: some View {
        ScreenShell(
            chapter: "A small first step",
            title: "Don't leave it to remembering.",
            subtitle: "Make space for a quiet check-in. Follow your clinician's advice on when and how often to measure.",
            detail: "A routine you choose. A reminder you control.",
            cta: "Choose my moment",
            onContinue: done
        ) {
            VStack(spacing: 8) {
                ForEach(choices, id: \.self) { c in
                    ChoiceCard(text: c, selected: answers.routine == c) { answers.routine = c }
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 10: Health

private struct S10_Health: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    let skip: () -> Void

    var body: some View {
        ScreenShell(
            chapter: "Keep it together",
            title: "Your readings, in one place.",
            subtitle: "Connect Apple Health to bring in available readings. You choose what to share in the Health permissions screen.",
            detail: "Optional. You can log readings manually and connect later.",
            cta: "Connect Apple Health",
            secondary: "Not now",
            onContinue: done,
            onSecondary: skip
        ) {
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(DS.Color.card)
                        .frame(width: 80, height: 80)
                    Image(systemName: "heart.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.red)
                }
                Spacer()
            }
            .padding(.vertical, 32)
        }
    }
}

// MARK: - Screen 11: Reminder

private struct S11_Reminder: View {
    @Binding var answers: OnboardingAnswers
    let done: () -> Void
    let skip: () -> Void

    var body: some View {
        ScreenShell(
            chapter: "Make it easier",
            title: "A gentle nudge. On your terms.",
            subtitle: "Choose a reminder time that works for you. Keep measurement timing aligned with your care plan.",
            detail: "Optional. You can change or turn reminders off anytime.",
            cta: "Use this reminder",
            secondary: "Not now",
            onContinue: done,
            onSecondary: skip
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text("REMINDER TIME")
                    .font(DS.Font.mono(10))
                    .foregroundStyle(DS.Color.textMuted)
                DatePicker("", selection: $answers.reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .frame(maxWidth: .infinity)
                    .background(DS.Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Screen 12: Begin

private struct S12_Begin: View {
    let onLog: () -> Void
    let onExplore: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(DS.Color.red.opacity(0.06))
                        .frame(width: 180, height: 180)
                    Circle()
                        .fill(DS.Color.red.opacity(0.03))
                        .frame(width: 240, height: 240)
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 56))
                        .foregroundStyle(DS.Color.red)
                }

                VStack(spacing: 10) {
                    Text("THE NEXT CHAPTER")
                        .font(DS.Font.mono(10))
                        .foregroundStyle(DS.Color.red.opacity(0.7))
                    Text("Your record begins\nwith one reading.")
                        .font(DS.Font.grotesk(28, weight: .light))
                        .foregroundStyle(DS.Color.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Follow your monitor's instructions and your clinician's advice.")
                        .font(DS.Font.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }

            Spacer()

            VStack(spacing: 8) {
                PrimaryButton(title: "Log my first reading →", action: onLog)
                Button("Explore my dashboard") { onExplore() }
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
                    .frame(height: 36)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 40)
        }
        .background(DS.Color.background.ignoresSafeArea())
    }
}
