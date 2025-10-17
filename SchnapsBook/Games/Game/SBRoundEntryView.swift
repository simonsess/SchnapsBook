import SwiftUI
import SwiftData

struct SBRoundEntryView: View {
    @Environment(\.dismiss) private var dismiss
    public var viewModel: SchnapsGameViewModel
    
    init(viewModel: SchnapsGameViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Button("Add") {
                if let game = viewModel.game {
                    let round = SBGameRound(voter: game.playerToVote, voterWon: true, players: game.players, gameType: .basic(with33: true), water: .with)
                    viewModel.addRound(round: round)
                }
                dismiss()
            }
        }
    }
}

#Preview {
//    SBRoundEntryView()
}
