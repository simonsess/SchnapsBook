import SwiftUI
import SwiftData

struct SchnapsGameView: View {
    @State var roundToPopup: SBGameRound? = nil
    @State var voterIndex: Int?
    @State private var roundSheet: Bool = false
    @StateObject private var viewModel: SchnapsGameViewModel
    
    init(gameId: UUID, context: ModelContext) {
        let vm = SchnapsGameViewModel(gameId: gameId, context: context)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(content: {
                        ForEach(viewModel.scoreRounds.keys.sorted(), id: \.self) { roundNo in
                            rowView(roundNo: roundNo)
                                .onTapGesture {
                                    showRoundDetail(round: viewModel.round(index: roundNo))
                                }
                        }
                    }, header: {
                        headerView()
                            .padding(.bottom, 5)
                    })
                }
                .padding(.horizontal, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollBounceBehavior(.basedOnSize)
            .background(.backgroundPrimary)
            
            if let roundToPopup {
                SBPopupCard(content: {
                    RoundDetailPopup(round: roundToPopup, dismiss: {
                        self.roundToPopup = nil
                    }, edit: {
                        
                    })
                }, dismiss: {
                    self.roundToPopup = nil
                })
            }
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction, content: {
                Button(action: {
                    roundSheet = true
                }, label: {
                    Label("Add Item", systemImage: "plus")
                })
            })

            ToolbarItem(placement: .secondaryAction) {
                Button("Reset Scores", action: {/* TODO: Implement reset logic */})
                    .tint(.red)
            }
            ToolbarItem(placement: .secondaryAction) {
                Button("Export Data", action: {/* TODO: Implement export logic */})
            }
            ToolbarItem(placement: .secondaryAction) {
                Button("Settings", action: {/* TODO: Implement settings logic */})
                    .tint(.yellow)
            }
            
        }
        .sheet(isPresented: $roundSheet, content: {
            if let newRoundNumber = viewModel.newRoundNumber {
                SBRoundEntryView(viewModel: viewModel, voter: viewModel.newRoundVoter, roundNumber: newRoundNumber)
            }
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
                .background(Color.backgroundTertiary)
            ForEach(viewModel.sortedPlayers, id: \.self) { player in
                Text(player.name)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background(Color.backgroundTertiary)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(.foregroundPrimary)
        .background(.backgroundPrimary)
    }
    
    @ViewBuilder
    func rowView(roundNo: Int) -> some View {
        HStack(spacing: 2) {
            HStack (spacing: 0) {
                Text("\(roundNo + 1)")
                    .frame(maxWidth: 30)
                    .font(.body)
                    .foregroundStyle(.foregroundPrimary)
                Rectangle()
                    .frame(maxHeight: .infinity)
                    .frame(width: 2)
                    .foregroundStyle(.foregroundPrimary)
            }
            let scores = viewModel.scoreRounds[roundNo]
            if let round = viewModel.round(index: roundNo) {
                ForEach(0..<4, content: { i in
                    let player = viewModel.sortedPlayers[i]
                    if let scores, let score = scores[player.id] {
                        Text("\(score)")
                            .cellFontStyle(viewModel.isPLayerVoter(round: round, playerRank: i))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(viewModel.cellBackground(in: round, for: i))
                            .minimumScaleFactor(0.5)
                            .padding(.vertical, 1)
                            .foregroundStyle(.foregroundPrimary)
                            .cornerRadius(8)
                    }
                })
            }
        }
        .frame(height: 30)
    }
    
    func showRoundDetail(round: SBGameRound?) {
        guard let round else {
            return
        }
        withAnimation(.spring()) {
            roundToPopup = round
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
            let round = SBGameRound(voter: game.players[0], voterWon: true, gameType: .normal, order: 1)
            container.mainContext.insert(round)
            game.rounds.append(round)
            
            let round2 = SBGameRound(voter: game.players[1], voterWon: true, gameType: .normal, kontra: .normal, cheater: game.players[0], order: 2)
            container.mainContext.insert(round2)
            game.rounds.append(round2)
            return container
        }
        return try! ModelContainer(for: SBGame.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }()
}
#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    
    return SchnapsGameView(gameId: game.id, context: SchnapsGameView.preview.mainContext)
}
