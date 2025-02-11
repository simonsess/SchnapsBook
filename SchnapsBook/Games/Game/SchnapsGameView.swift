import SwiftUI
import SwiftData

struct SchnapsGameView: View {
    @Query var games: [SBGame]
    @Environment(\.modelContext) private var modelContext
    @State var voterIndex: Int?
    @State private var game: SBGame?
    
    init(gameId: UUID) {
        print("\(gameId)")
        _games = Query(filter: #Predicate<SBGame> { $0.id == gameId })
    }
    
    var body: some View {
        VStack {
            if let game = game {
                ScrollView {
                    Text("this is Game detail of \(game.name)")
                    Text("Players")
                    ForEach(game.players) { player in
                        Text("name: \(player.name)")
                    }
                    ForEach(game.rounds) { reound in
                        Text("round")
                    }
                    Button(action: {
                        if let pl = game.players.first {
                            let round = SBGameRound(voter: pl, voterWon: true, gameType: .basic, water: .with)
                            game.rounds.append(round)
                        }
                        
                    }, label: {
                        Text("Add round")
                    })
                }
                .background(.gray)
                .padding(.bottom, 100)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .onAppear(perform: {
            initSetup()
        })
    }
    
    func initSetup() {
        print("initSetup")
        print("games count: \(games.count)")
        game = games.first
    }
}

///Preview
extension SchnapsGameView {
    @MainActor
    static var preview: ModelContainer = {
        let schema = Schema([
            SBGame.self,
            SBPlayer.self,
            SBGameRound.self
        ])
        
        if let container = try? ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true)) {
            let game = SBGame.mockGame(modelContext: container.mainContext)
            container.mainContext.insert(game)
            let round = SBGameRound(voter: game.players.first!, voterWon: true, gameType: .basic, water: .with)
            container.mainContext.insert(round)
            game.rounds.append(round)
            return container
        }
        return try! ModelContainer(for: SBGame.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }()
}
#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    
    return SchnapsGameView(gameId: game.id)
        .modelContext(SchnapsGameView.preview.mainContext)
}
