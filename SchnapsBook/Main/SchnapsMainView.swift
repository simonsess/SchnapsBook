import SwiftUI
import SwiftData

struct SchnapsMainView: View {
    init() {
        UINavigationBar.setCustomTitleColor(UIColor.foregroundPrimary)
//        let unselectedColor = UIColor.foregroundSecondary
//        UITabBar.appearance().unselectedItemTintColor = unselectedColor
//        let selectedColor = UIColor.foregroundPrimary
//        UITabBar.appearance().tintColor = selectedColor
    }
    
    var body: some View {
        TabView {
            SchnapsGamesView()
                .tabItem {
                    Label("Games", systemImage: "flag.checkered.2.crossed")
                }
            
            PlayersView()
                
                .tabItem {
                    Label("Players", systemImage: "person.3.fill")
                        .foregroundStyle(Color.foregroundPrimary)
                }
            
//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gear")
//                }
        }
        .tint(Color.foregroundTabTint)
    }
}

#Preview {
    SchnapsMainView()
        .modelContainer(for: [SBGame.self,SBPlayer.self, SBGameRound.self], inMemory: true)
}
