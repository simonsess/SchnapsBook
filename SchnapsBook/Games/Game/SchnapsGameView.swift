import SwiftUI
import SwiftData

struct SchnapsGameView: View {
    @State var voterIndex: Int?
    @State private var roundSheet: Bool = false
    @StateObject private var viewModel: SchnapsGameViewModel
    
    init(gameId: UUID, context: ModelContext) {
        let vm = SchnapsGameViewModel(gameId: gameId, context: context)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.gameName)
                    .foregroundStyle(.primary)
                Spacer()
            }
            Divider()
            headerView()
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.scoreRounds.keys.sorted(), id: \.self) { roundNo in
                        rowView(roundNo: roundNo)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .scrollBounceBehavior(.basedOnSize)
            .background(.gray)
            .padding(.bottom, 100)
            
            Button(action: {
                roundSheet = true
            }, label: {
                Text("Add round")
            })
            .padding()
        }
        
        .padding(.horizontal, 20)
        .sheet(isPresented: $roundSheet, content: {
            if let game = viewModel.game {
                SBRoundEntryView(viewModel: viewModel)
            }
        })
        
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(spacing: 1) {
            ForEach(viewModel.sortedPlayers, id: \.self) { player in
                Text(player.name)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.lightGray))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .background(.black)
    }
    
    @ViewBuilder
    func rowView(roundNo: Int) -> some View {
        HStack {
            let scores = viewModel.scoreRounds[roundNo]
            ForEach(0..<4, content: { i in
                let player = viewModel.sortedPlayers[i]
                if let scores, let score = scores[player.id] {
                    Text("\(score)")
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isPlayerVoterTeam(round: viewModel.rounds[roundNo], playerRank: i) ? Color.mint : Color.clear)
                        
                }
            })
        }
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
            let round = SBGameRound(voter: game.players.first!, voterWon: true, players: game.players, gameType: .basic(with33: true), water: .with)
            container.mainContext.insert(round)
            game.rounds.append(SBGameRoundLink(index: game.rounds.count, round: round))
            return container
        }
        return try! ModelContainer(for: SBGame.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }()
}
#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    
    return SchnapsGameView(gameId: game.id, context: SchnapsGameView.preview.mainContext)
}
