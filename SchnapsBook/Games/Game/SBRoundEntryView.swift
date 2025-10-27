import SwiftUI
import SwiftData

struct SBRoundEntryView: View {
    @Environment(\.dismiss) private var dismiss
    public var viewModel: SchnapsGameViewModel
    public var voter: String
    public var roundNumber: Int
    
    @State private var voterWon: Bool = true
    @State private var gameType: SBGameType = .normal
    @State private var cheaterSwitch: Bool = false
    @State private var cheater: UUID = UUID.zero
    @State private var teammate: Teammate = Teammate.noTeammates
    @State private var water: Bool = false
    @State private var kontra: SBKontra = .normal
    
    var round: SBGameRound? = nil
    var isEditing: Bool {
        round != nil
    }
    
    init(viewModel: SchnapsGameViewModel, voter: String, roundNumber: Int, voterWon: Bool, gameType: SBGameType, cheaterSwitch: Bool, cheater: UUID, teammate: Teammate, water: Bool, kontra: SBKontra, round: SBGameRound? = nil) {
        self.viewModel = viewModel
        self.voter = voter
        self.roundNumber = roundNumber
        self.voterWon = voterWon
        self.gameType = gameType
        self.cheaterSwitch = cheaterSwitch
        self.cheater = cheater
        self.teammate = teammate
        self.water = water
        self.kontra = kontra
        self.round = round
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            VStack {
                Text("Round \(roundNumber + 1)")
                    .font(.subheadline)
                    .foregroundStyle(Color.foregroundPrimary)
                Text("Voter: \(voter)")
                    .font(.largeTitle)
                    .foregroundStyle(Color.foregroundPrimary)
                Form {
                    Section(content: {
                        Picker("Teammate", selection: $teammate) {
                            ForEach(viewModel.coopPlayersSet) { mate in
                                Text(mate.name ?? "Alone").tag(mate)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        .disabled(cheaterSwitch)
                        
                        Toggle("Voter team won", isOn: $voterWon)
                            .disabled(cheaterSwitch)
                            .tint(Color.foregroundTabTint)
                            .foregroundStyle(Color.foregroundPrimary)
                        
                        Picker("Type", selection: $gameType) {
                            ForEach(SBGameType.allCases) { type in
                                Text(type.name).tag(type)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        
                        Picker("Contra", selection: $kontra) {
                            ForEach(SBKontra.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        
                        Spacer()
                        
                        Toggle("Cheater", isOn: $cheaterSwitch)
                            .tint(Color.foregroundTabTint)
                            .foregroundStyle(Color.foregroundPrimary)
                        
                        Picker("Cheater", selection: $cheater) {
                            ForEach(viewModel.gamePlayersSet) { player in
                                Text(player.name ?? "").tag(player.id)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        .disabled(!cheaterSwitch)
                    }, header: {
                        Text("Round")
                    })
                    .listRowBackground(Color.backgroundSecondary)
                }
                .formStyling()
                SBPrimaryButton(action: addRound, title: "Submit")
                    .disabledStyling(isDisabled: cheaterSwitch &&  cheater == UUID.zero)
                SBSecondaryButton(action: {
                    mockRounds()
                }, title: "mock")
                SBSecondaryButton(action: {
                    mockRounds2()
                }, title: "moc2")
            }
            .background(Color.backgroundPrimary)
            .padding(.vertical)
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    
    func mockRounds() {
            guard let game = viewModel.game else {
                //error
                return
            }
        var roundNo = game.rounds.count
        var round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[3].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[0].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[3].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[2].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: game.playerToVote, coop: nil, voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
            
            dismiss()
        }
        
    private func mockRounds2() {
        guard let game = viewModel.game else {
            //error
            return
        }
        var roundNo = game.rounds.count
        var round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[3].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
        viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[2].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
        viewModel.addRound(round: round)
        mockRounds()
    }

    
    private func addRound() {
        guard let game = viewModel.game else {
            //error
            return
        }
        if cheaterSwitch {
            guard cheater != UUID.zero else {
                return
            }
        }
        let round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: teammate.id), voterWon: voterWon, gameType: gameType, kontra: kontra, cheater: viewModel.playerFromId(id: cheater), order: game.rounds.count)
        viewModel.addRound(round: round)
        dismiss()
    }
}

#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    
    SBRoundEntryView(viewModel: SchnapsGameViewModel(gameId: game.id, context: SchnapsGameView.preview.mainContext), voter: "Simon", roundNumber: 12)
}
