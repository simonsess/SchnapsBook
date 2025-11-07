import SwiftUI
import SwiftData

struct SchnapsGameView: View {
    @State var roundDetailInPopup: SBGameRound? = nil
    @State var voterIndex: Int?
    @State private var showNewRoundEntrySheet: Bool = false
    @State private var showRoundSheetEditor: Bool = false
    
    @State private var votedCard: Card? = nil
    @State var showVotedCard: Bool = false
    
    @Bindable var viewModel: SchnapsGameViewModel

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(content: {
                        ForEach(viewModel.game.rounds.indices, id: \.self) { roundNo in
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
            
            
            if let roundDetailInPopup {
                SBPopupCard(content: {
                    RoundDetailPopup(round: roundDetailInPopup, dismiss: {
                        animateActiveRound(round: nil)
                    }, edit: {
                        self.showRoundSheetEditor = true
                    })
                }, dismiss: {
                    self.roundDetailInPopup = nil
                })
            }
            
            if showVotedCard {
                SBPopupCard(content: {
                    VotedCardHelperView(card: $votedCard, roundNo: viewModel.game.rounds.count, voter: viewModel.game.playerToVote.name)
                }, dismiss: {
                    showVotedCard = false
                })
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            //MARK Bottom buttons
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(.spring()) {
                        showVotedCard = true
                    }
                }, label: {
                    Image(systemName: "rectangle.portrait" + (votedCard != nil ? ".fill" : ""))
                        .resizable()
                        .scaledToFit()
                        .padding(15)
                        .foregroundStyle(.foregroundTabTint)
                })
                .frame(width: 64, height: 64)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 8)
                Spacer()
                Button(action: {
                    showNewRoundEntrySheet = true
                    showVotedCard = false
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.foregroundTabTint)
                })
                .font(.system(size: 30, weight: .regular))
                .frame(width: 64, height: 64)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 8)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 40)
        })
        .onAppear(){
            viewModel.processRounds()
        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Menu {
//                    Button("vote card") {
//                        withAnimation(.spring()) {
//                            showVotedCard = true
//                        }
//                    }
//                    Button("Option 2") {}
//                } label: {
//                    Label("More", systemImage: "ellipsis.circle")
//                }
//                .tint(.foregroundTabTint)
//            }
//        }
        .sheet(isPresented: $showNewRoundEntrySheet, content: {
            SBRoundEntryView(viewModel: SBRoundEntryViewModel(roundToEdit: nil, game: viewModel.game), completion: { round in
                guard let round else {
                    return
                }
                viewModel.addRound(round: round)
                votedCard = nil
            })
        })
        .sheet(isPresented: $showRoundSheetEditor, onDismiss: {
            roundDetailInPopup = nil
        }, content: {
            SBRoundEntryView(viewModel: SBRoundEntryViewModel(roundToEdit: roundDetailInPopup, game: viewModel.game), completion: { _ in
                animateActiveRound(round: nil)
                viewModel.processRounds()
            })
        })
        .navigationTitle(viewModel.game.name)
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
            ForEach(viewModel.game.sortedPlayers, id: \.self) { player in
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
                    .opacity(0.3)
            }
            let scores = viewModel.scoreForRound(round: roundNo)
            if let round = viewModel.round(index: roundNo) {
                ForEach(0..<4, content: { i in
                    let player = viewModel.game.sortedPlayers[i]
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
        animateActiveRound(round: round)
    }
    
    func animateActiveRound(round: SBGameRound?) {
        withAnimation(.spring()) {
            roundDetailInPopup = round
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
            let round = SBGameRound(voter: game.players[0], voterWon: true, gameType: .normal, order: 0)
            container.mainContext.insert(round)
            game.rounds.append(round)
            
            let round2 = SBGameRound(voter: game.players[1], voterWon: true, gameType: .normal, kontra: .normal, cheater: game.players[3], order: 1)
            container.mainContext.insert(round2)
            game.rounds.append(round2)
            return container
        }
        return try! ModelContainer(for: SBGame.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }()
}
#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!

    return SchnapsGameView(viewModel: SchnapsGameViewModel(game: game))
        .modelContainer(SchnapsGameView.preview)
}
