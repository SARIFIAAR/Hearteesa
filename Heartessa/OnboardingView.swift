import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @AppStorage("heartessa.hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var page = 0

    var body: some View {
        TabView(selection: $page) {
            OnboardingScreen1(onSkip: { hasSeenOnboarding = true },
                              onNext: { page = 1 }).tag(0)
            OnboardingScreen2(onNext: { page = 2 }).tag(1)
            OnboardingScreen3(onDone: { hasSeenOnboarding = true }).tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea()
        .tint(Color(hex: "#2D9D6E"))
    }
}

// MARK: - Screen 1: Hero

private struct OnboardingScreen1: View {
    let onSkip: () -> Void
    let onNext: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#1A6B4A"), Color(hex: "#0D3D2B")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip", action: onSkip)
                        .font(.subheadline).foregroundStyle(.white.opacity(0.7))
                        .padding()
                }

                Spacer()

                VStack(spacing: 24) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 12)

                    VStack(spacing: 12) {
                        Text("Blood pressure,\nbeautifully tracked.")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        Text("Log readings in seconds. Spot trends.\nShare clean reports. Free, forever.")
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()

                Button(action: onNext) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.white)
                        .foregroundStyle(Color(hex: "#1A6B4A"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }
}

// MARK: - Screen 2: Demo

private struct OnboardingScreen2: View {
    let onNext: () -> Void
    @State private var animStep = 0

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Log in seconds")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("Systolic, diastolic, pulse — arm and\nposition so readings stay meaningful.")
                .font(.body).foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Animated reading demo
            VStack(spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    AnimatedNumber(target: animStep >= 1 ? 124 : 0, label: "Systolic")
                    Text("/").font(.system(size: 36, weight: .light)).foregroundStyle(.secondary)
                    AnimatedNumber(target: animStep >= 2 ? 82 : 0, label: "Diastolic")
                }

                if animStep >= 3 {
                    CategoryBadge(systolic: 124, diastolic: 82)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(28)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 32)

            Spacer()

            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#2D9D6E"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .onAppear { runAnimation() }
    }

    private func runAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { withAnimation(.spring) { animStep = 1 } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { withAnimation(.spring) { animStep = 2 } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) { withAnimation(.spring) { animStep = 3 } }
    }
}

private struct AnimatedNumber: View {
    let target: Int
    let label: String
    @State private var displayed = 0

    var body: some View {
        VStack(spacing: 4) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text("\(displayed)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.6), value: displayed)
        }
        .onChange(of: target) { _, v in displayed = v }
    }
}

// MARK: - Screen 3: Notifications

private struct OnboardingScreen3: View {
    let onDone: () -> Void
    @State private var requested = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "bell.badge.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color(hex: "#2D9D6E"))

            VStack(spacing: 12) {
                Text("Daily reminders")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Text("Get a gentle nudge at 8 AM to log your\nmorning reading — the most important one.")
                    .font(.body).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    Task {
                        _ = try? await UNUserNotificationCenter.current()
                            .requestAuthorization(options: [.alert, .sound])
                        onDone()
                    }
                } label: {
                    Text("Enable Reminders")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#2D9D6E"))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button("Not Now", action: onDone)
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
    }
}
