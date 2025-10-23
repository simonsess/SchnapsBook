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
    
    var body: some View {
        VStack {
            Text("Round \(roundNumber + 1)")
                .font(.subheadline)
            Text("Voter: \(voter)")
                .font(.headline)
            Form {
                Picker("Teammate", selection: $teammate) {
                    ForEach(viewModel.coopPlayersSet) { mate in
                        Text(mate.name ?? "Alone").tag(mate)
                    }
                }
                .pickerStyle(.menu)
                .disabled(cheaterSwitch)
                
                Toggle("Voter team won", isOn: $voterWon)
                .disabled(cheaterSwitch)
                
                Picker("Type", selection: $gameType) {
                    ForEach(SBGameType.allCases) { type in
                        Text(type.name).tag(type)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Contra", selection: $kontra) {
                    ForEach(SBKontra.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.menu)
                
                Spacer()
                
                Toggle("Cheater", isOn: $cheaterSwitch)
                
                Picker("Cheater", selection: $cheater) {
                    ForEach(viewModel.gamePlayersSet) { player in
                        Text(player.name ?? "").tag(player.id)
                    }
                }
                .pickerStyle(.menu)
                .disabled(!cheaterSwitch)
                
                Button("Submit") {
                    guard let game = viewModel.game, cheater != UUID.zero else {
                        //error
                        return
                    }
                    let round = SBGameRound(voter: game.playerToVote, coop: viewModel.playerFromId(id: teammate.id), voterWon: voterWon, gameType: gameType, kontra: kontra, cheater: viewModel.playerFromId(id: cheater))
                    viewModel.addRound(round: round)
                    dismiss()
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    
    SBRoundEntryView(viewModel: SchnapsGameViewModel(gameId: game.id, context: SchnapsGameView.preview.mainContext), voter: "Simon", roundNumber: 12)
}
