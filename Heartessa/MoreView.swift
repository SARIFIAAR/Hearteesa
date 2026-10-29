import SwiftUI
import UserNotifications

struct MoreView: View {
    @State private var remindersEnabled = false
    @State private var reminderTime = Calendar.current.date(
        bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var permissionDenied = false

    var body: some View {
        NavigationStack {
            List {
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
                        Label("Enable notifications in Settings to use reminders.",
                              systemImage: "exclamationmark.triangle.fill")
                            .font(.caption).foregroundStyle(.orange)
                    }
                }

                Section("BP Standard") {
                    LabeledContent("Current", value: "ACC/AHA 2025")
                        .foregroundStyle(.secondary)
                }

                Section("About") {
                    LabeledContent("Version",
                        value: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0")
                    LabeledContent("App ID", value: "com.heartessa.app")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("More")
        }
        .task { await refreshPermissionStatus() }
    }

    private func refreshPermissionStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        permissionDenied = settings.authorizationStatus == .denied
    }

    private func scheduleReminder() async {
        let center = UNUserNotificationCenter.current()
        let status = await center.notificationSettings()

        if status.authorizationStatus == .notDetermined {
            guard (try? await center.requestAuthorization(options: [.alert, .sound])) == true else {
                permissionDenied = true
                remindersEnabled = false
                return
            }
        } else if status.authorizationStatus == .denied {
            permissionDenied = true
            remindersEnabled = false
            return
        }

        center.removePendingNotificationRequests(withIdentifiers: ["heartessa.daily"])

        let content = UNMutableNotificationContent()
        content.title = "Heartessa"
        content.body = "Time to log your blood pressure"
        content.sound = .default

        var comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        comps.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(
            identifier: "heartessa.daily", content: content, trigger: trigger)
        try? await center.add(request)
    }

    private func cancelReminders() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["heartessa.daily"])
    }
}
