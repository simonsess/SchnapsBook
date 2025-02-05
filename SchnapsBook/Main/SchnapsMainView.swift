import SwiftUI
import SwiftData

struct SchnapsMainView: View {
    var body: some View {
        TabView {
            SchnapsGamesView()
                .tabItem {
                    Label("Games", systemImage: "flag.checkered.2.crossed")
                }
            
            PlayersView()
                .tabItem {
                    Label("Players", systemImage: "person.3.fill")
                }
            
//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gear")
//                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    SchnapsMainView()
        .modelContainer(for: [SBGame.self,SBPlayer.self, SBGameRound.self], inMemory: true)
}
