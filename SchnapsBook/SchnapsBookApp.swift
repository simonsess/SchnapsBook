import SwiftUI
import SwiftData

@main
struct SchnapsBookApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SBGame.self,
            SBPlayer.self,
            SBGameRound.self
        ])
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isPreview)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SchnapsMainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
