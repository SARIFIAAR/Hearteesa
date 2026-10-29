import SwiftUI
import SwiftData
import UserNotifications
import RevenueCat

struct MoreView: View {
    @Query private var readings: [BPReading]

    @State private var remindersEnabled = false
    @State private var reminderTime = Calendar.current.date(
        bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var permissionDenied = false

    @AppStorage("heartessa.bpStandard") private var bpStandard = "accaha"
    @AppStorage("heartessa.biometricEnabled") private var biometricEnabled = false

    @State private var showPaywall = false
    @State private var isPremium = false
    @State private var csvItem: ShareableData?
    @State private var pdfItem: ShareableData?

    var body: some View {
        NavigationStack {
            List {
                exportSection
                premiumSection
                reminderSection
                standardSection
                privacySection
                aboutSection
            }
            .navigationTitle("More")
        }
        .sheet(isPresented: $showPaywall) { PaywallView(onPurchased: { isPremium = true }) }
        .task { await refreshState() }
    }

    // MARK: - Sections

    private var exportSection: some View {
        Section("Export") {
            Button {
                let data = ExportService.csvData(readings: readings)
                csvItem = ShareableData(data: data,
                                        filename: "heartessa_export.csv",
                                        contentType: "text/csv")
            } label: {
                Label("Export CSV", systemImage: "tablecells")
            }
            .shareSheet(item: $csvItem)

            Button {
                let data = ExportService.pdfData(readings: readings)
                pdfItem = ShareableData(data: data,
                                        filename: "heartessa_report.pdf",
                                        contentType: "application/pdf")
            } label: {
                Label("Export PDF Report", systemImage: "doc.richtext")
            }
            .shareSheet(item: $pdfItem)
        }
    }

    private var premiumSection: some View {
        Section("Premium") {
            Button {
                showPaywall = true
            } label: {
                HStack {
                    Label("Apple Watch Logging", systemImage: "applewatch")
                    Spacer()
                    if isPremium {
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    } else {
                        Text("Upgrade").font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .foregroundStyle(.primary)

            Button {
                showPaywall = true
            } label: {
                HStack {
                    Label("iCloud Sync", systemImage: "icloud.fill")
                    Spacer()
                    if isPremium {
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    } else {
                        Text("Upgrade").font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .foregroundStyle(.primary)
        }
    }

    private var reminderSection: some View {
        Section("Daily Reminder") {
            Toggle("Remind me", isOn: $remindersEnabled)
                .onChange(of: remindersEnabled) { _, on in
                    if on { Task { await scheduleReminder() } }
                    else { cancelReminders() }
                }

            if remindersEnabled {
                DatePicker("Time", selection: $reminderTime,
                           displayedComponents: .hourAndMinute)
                    .onChange(of: reminderTime) { _, _ in
                        if remindersEnabled { Task { await scheduleReminder() } }
                    }
            }

            if permissionDenied {
                Label("Enable notifications in Settings.",
                      systemImage: "exclamationmark.triangle.fill")
                    .font(.caption).foregroundStyle(.orange)
            }
        }
    }

    private var standardSection: some View {
        Section {
            Picker("BP Standard", selection: $bpStandard) {
                Text("ACC/AHA 2025").tag("accaha")
                Text("ESC/ESH 2018").tag("esc2018")
            }
            .pickerStyle(.segmented)

            if bpStandard == "esc2018" {
                Text("Optimal <120/80  ·  Normal 120–129/80–84  ·  High Normal 130–139/85–89  ·  Grade 1–3")
                    .font(.caption2).foregroundStyle(.secondary)
            }
        } header: {
            Text("Classification Standard")
        }
    }

    private var privacySection: some View {
        Section("Privacy") {
            Toggle("Face ID Lock", isOn: $biometricEnabled)
        }
    }

    private var aboutSection: some View {
        Section("About") {
            LabeledContent("Version",
                value: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0")
            LabeledContent("App", value: "Heartessa")
                .foregroundStyle(.secondary)
            LabeledContent("Readings", value: "\(readings.count)")
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Helpers

    private func refreshState() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        permissionDenied = settings.authorizationStatus == .denied

        if let info = try? await Purchases.shared.customerInfo() {
            isPremium = info.entitlements["premium"]?.isActive == true
        }
    }

    private func scheduleReminder() async {
        let center = UNUserNotificationCenter.current()
        let status = await center.notificationSettings()

        if status.authorizationStatus == .notDetermined {
            guard (try? await center.requestAuthorization(options: [.alert, .sound])) == true else {
                permissionDenied = true; remindersEnabled = false; return
            }
        } else if status.authorizationStatus == .denied {
            permissionDenied = true; remindersEnabled = false; return
        }

        center.removePendingNotificationRequests(withIdentifiers: ["heartessa.daily"])
        let content = UNMutableNotificationContent()
        content.title = "Heartessa"
        content.body = "Time to log your blood pressure"
        content.sound = .default
        var comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        comps.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        try? await center.add(UNNotificationRequest(identifier: "heartessa.daily",
                                                     content: content, trigger: trigger))
    }

    private func cancelReminders() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["heartessa.daily"])
    }
}

// MARK: - Share sheet helpers

struct ShareableData: Identifiable {
    let id = UUID()
    let data: Data
    let filename: String
    let contentType: String

    var tempURL: URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try? data.write(to: url)
        return url
    }
}

private extension View {
    func shareSheet(item: Binding<ShareableData?>) -> some View {
        sheet(item: item) { shareable in
            ShareSheetView(url: shareable.tempURL)
                .ignoresSafeArea()
        }
    }
}

struct ShareSheetView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
