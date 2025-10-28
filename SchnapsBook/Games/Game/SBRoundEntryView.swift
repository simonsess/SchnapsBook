import SwiftUI
import SwiftData

struct SBRoundEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable public var viewModel: SBRoundEntryViewModel
    
    public var completion: (SBGameRound?) -> Void
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            VStack {
                Text("Round \(viewModel.roundNumber + 1)")
                    .font(.subheadline)
                    .foregroundStyle(Color.foregroundPrimary)
                Text("Voter: \(viewModel.roundVoter)")
                    .font(.largeTitle)
                    .foregroundStyle(Color.foregroundPrimary)
                Form {
                    Section(content: {
                        Picker("Teammate", selection: $viewModel.teammate) {
                            ForEach(viewModel.coopPlayersSet) { mate in
                                Text(mate.name ?? "Alone").tag(mate)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        .disabled(viewModel.cheaterSwitch)
                        
                        Toggle("Voter team won", isOn: $viewModel.voterWon)
                            .disabled(viewModel.cheaterSwitch)
                            .tint(Color.foregroundTabTint)
                            .foregroundStyle(Color.foregroundPrimary)
                        
                        Picker("Type", selection: $viewModel.gameType) {
                            ForEach(SBGameType.allCases) { type in
                                Text(type.name).tag(type)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        
                        Picker("Contra", selection: $viewModel.kontra) {
                            ForEach(SBKontra.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        
                        Spacer()
                        
                        Toggle("Cheater", isOn: $viewModel.cheaterSwitch)
                            .tint(Color.foregroundTabTint)
                            .foregroundStyle(Color.foregroundPrimary)
                        
                        Picker("Cheater", selection: $viewModel.cheater) {
                            ForEach(viewModel.gamePlayersSet) { player in
                                Text(player.name ?? "").tag(player)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                        .disabled(!viewModel.cheaterSwitch)
                    }, header: {
                        Text("Round")
                    })
                    .listRowBackground(Color.backgroundSecondary)
                }
                .formStyling()
                SBPrimaryButton(action: processActiveRound, title: viewModel.isEditing ? "Update" : "Submit")
                    .disabledStyling(isDisabled: viewModel.cheaterSwitch &&  viewModel.cheater.id == UUID.zero)
//                SBSecondaryButton(action: {
//                    mockRounds()
//                }, title: "mock")
//                SBSecondaryButton(action: {
//                    mockRounds2()
//                }, title: "moc2")
            }
            .background(Color.backgroundPrimary)
            .padding(.vertical)
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    
    private func  processActiveRound() {
        if viewModel.isEditing {
            viewModel.updateRound()
            completion(nil)
        } else {
            let round = viewModel.addRound()
            completion(round)
        }
        dismiss()
    }
    
    /*
    func mockRounds() {
        var roundNo = viewModel.game.rounds.count
        var round = SBGameRound(voter: viewModel.game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[3].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: viewModel.game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[0].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: viewModel.game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[3].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: viewModel.game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[2].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: viewModel.game.playerToVote, coop: nil, voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
            viewModel.addRound(round: round)
            
            dismiss()
        }
        
    private func mockRounds2() {
        var roundNo = viewModel.game.rounds.count
        var round = SBGameRound(voter: viewModel.game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[3].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
        viewModel.addRound(round: round)
        roundNo += 1
        round = SBGameRound(voter: viewModel.game.playerToVote, coop: viewModel.playerFromId(id: viewModel.coopPlayersSet[2].id), voterWon: true, gameType: .normal, kontra: .normal, cheater: nil, order: roundNo)
        viewModel.addRound(round: round)
        mockRounds()
    }
     */

}

#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    
    SBRoundEntryView(viewModel: SBRoundEntryViewModel(game: game), completion: {_ in })
        .modelContainer(SchnapsGameView.preview)
}
