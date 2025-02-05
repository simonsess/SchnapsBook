import SwiftUI
import SwiftData

struct SchnapsGameView: View {
//    @Query private var players: [SBPlayer]
    @StateObject var game: SBGame
    
    var body: some View {
        ScrollView {
            Text("this is Game detail of \(game.name)")
            Text("Players")
            ForEach(game.players ?? []) { player in
                Text("name: \(player.name)")
            }
        }
        .background(.yellow)
    }
}

#Preview {
    SchnapsGameView(game: SBGame(name: "game", date: Date(), players: [], playerToVote: SBPlayer.mock(), rounds: []))
}
