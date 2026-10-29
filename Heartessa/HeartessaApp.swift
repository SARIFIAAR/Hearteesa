import SwiftUI
import SwiftData

@main
struct HeartessaApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([BPReading.self, UserProfile.self])
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            modelContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
