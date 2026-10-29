import SwiftUI
import SwiftData
import RevenueCat
import FirebaseCore
import LocalAuthentication

@main
struct HeartessaApp: App {
    let modelContainer: ModelContainer

    init() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "appl_CrdjebQuruAkIvSRQyMGeRFKTXS")

        do {
            let schema = Schema([BPReading.self, UserProfile.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(modelContainer)
    }
}

// MARK: - Root (onboarding gate + biometric lock)

struct RootView: View {
    @AppStorage("heartessa.hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("heartessa.biometricEnabled") private var biometricEnabled = false
    @State private var isLocked = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView()
            } else {
                ContentView()
                    .overlay {
                        if isLocked {
                            LockScreen(onUnlock: { isLocked = false })
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background && biometricEnabled {
                isLocked = true
            }
            if phase == .active && isLocked && biometricEnabled {
                authenticateWithBiometrics()
            }
        }
    }

    private func authenticateWithBiometrics() {
        let ctx = LAContext()
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            isLocked = false
            return
        }
        ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                           localizedReason: "Unlock Heartessa") { success, _ in
            DispatchQueue.main.async {
                if success { isLocked = false }
            }
        }
    }
}

// MARK: - Lock Screen

struct LockScreen: View {
    let onUnlock: () -> Void
    @AppStorage("heartessa.biometricEnabled") private var biometricEnabled = false

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color(hex: "#2D9D6E"))
                Text("Heartessa is locked")
                    .font(.headline)
                Button {
                    let ctx = LAContext()
                    guard ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                error: nil) else { return }
                    ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: "Unlock Heartessa") { ok, _ in
                        DispatchQueue.main.async { if ok { onUnlock() } }
                    }
                } label: {
                    Label("Unlock with Face ID", systemImage: "faceid")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#2D9D6E"))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 40)
            }
        }
    }
}
