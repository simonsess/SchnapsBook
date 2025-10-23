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
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(content: {
                    ForEach(viewModel.scoreRounds.keys.sorted(), id: \.self) { roundNo in
                        rowView(roundNo: roundNo)
                    }
                }, header: {
                    headerView()
                        .padding(.bottom, 5)
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollBounceBehavior(.basedOnSize)
        .background(.gray)
        .toolbar{
            ToolbarItem(placement: .primaryAction, content: {
                Button(action: {
                    roundSheet = true
                }, label: {
                    Label("Add Item", systemImage: "plus")
                })
            })
            
            ToolbarItem(placement: .secondaryAction, content: {
                Text("actions")
            })
        }
        .sheet(isPresented: $roundSheet, content: {
            SBRoundEntryView(viewModel: viewModel, voter: viewModel.newRoundVoter, roundNumber: viewModel.newRoundNumber)
        })
        .onAppear() {
            Task {
                await viewModel.fetchGameData()
            }
        }
        .navigationTitle(viewModel.gameName)
        .navigationBarTitleDisplayMode(.automatic)
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(spacing: 2) {
            Text("#")
                .font(.title2)
                .frame(maxWidth: 30, maxHeight: .infinity)
                .padding(.vertical, 5)
                .background(Color(UIColor.lightGray))
            ForEach(viewModel.sortedPlayers, id: \.self) { player in
                Text(player.name)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.lightGray))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .background(.gray)
    }
    
    @ViewBuilder
    func rowView(roundNo: Int) -> some View {
        HStack(spacing: 2) {
            HStack (spacing: 0) {
                Text("\(roundNo + 1)")
                    .frame(maxWidth: 30)
                    .font(.body)
                Rectangle()
                    .frame(maxHeight: .infinity)
                    .frame(width: 1)
                    .background(Color.black)
            }
            let scores = viewModel.scoreRounds[roundNo]
            let round = viewModel.rounds[roundNo]
            ForEach(0..<4, content: { i in
                let player = viewModel.sortedPlayers[i]
                if let scores, let score = scores[player.id] {
                    Text("\(score)")
                        .cellFontStyle(viewModel.isPLayerVoter(round: round, playerRank: i))
                        .frame(maxWidth: .infinity)
                        .background(viewModel.cellBackground(in: round, for: i))
                        .minimumScaleFactor(0.5)
                        .frame(maxHeight: .infinity)
                }
            })
        }
        .frame(height: 30)
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
            let round = SBGameRound(voter: game.players[0], voterWon: true, gameType: .normal)
            container.mainContext.insert(round)
            game.rounds.append(SBGameRoundLink(index: game.rounds.count, round: round))
            
            let round2 = SBGameRound(voter: game.players[1], voterWon: true, gameType: .normal, kontra: .re, cheater: game.players[0])
            container.mainContext.insert(round2)
            game.rounds.append(SBGameRoundLink(index: game.rounds.count, round: round2))
            return container
        }
        return try! ModelContainer(for: SBGame.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }()
}
#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    
    return SchnapsGameView(gameId: game.id, context: SchnapsGameView.preview.mainContext)
}
