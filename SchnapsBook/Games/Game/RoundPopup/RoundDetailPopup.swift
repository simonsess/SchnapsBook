import SwiftUI
import SwiftData

struct RoundDetailPopup: View {
    var round: SBGameRound
    
    var dismiss: () -> Void
    var edit: () -> Void

    var body: some View {
        VStack(spacing: 5) {
            Text("Round \(round.order + 1)")
                .font(.largeTitle)
                .padding(.bottom, 15)
            HStack {
                Text(round.cheater == nil ? "Winners" : "Cheater")
                    .font(.subheadline)
                    .foregroundStyle(Color.foregroundSecondary)
                Spacer()
            }
            .padding(.top, 10)
                Text(winerTeamNames())
                    .font(.headline)
            SBSeparator()
            HStack {
                Text("Game type")
                    .font(.subheadline)
                    .foregroundStyle(Color.foregroundSecondary)
                Spacer()
            }
            .padding(.top, 10)
            Text(round.gameType.name)
                .font(.headline)
                .foregroundStyle(Color.foregroundSecondary)
            SBSeparator()
            HStack {
                Text("Kontra")
                    .font(.subheadline)
                    .foregroundStyle(Color.foregroundSecondary)
                Spacer()
            }
            .padding(.top, 10)
            Text(round.kontra.displayName)
                .font(.headline)
                .foregroundStyle(Color.foregroundSecondary)
            SBSeparator()
                .padding(.bottom, 15)
            SBPrimaryButton(action: {
                edit()
            }, title: "Edit")
//            SBSecondaryButton(action: {
//                dismiss()
//            }, title: "Dismiss")
        }
        .padding()
        .foregroundStyle(Color.foregroundPrimary)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThickMaterial)
                .shadow(radius: 20)
        )
        .padding(.horizontal, 40)
    }
    
    private func gameType() -> String {
        round.gameType.name
    }
    private func winerTeamNames() -> String {
        guard round.cheater == nil else {
            return round.cheater?.name ?? "N/A"
        }
        var winners: [SBPlayer] = []
        var voterTeam: [SBPlayer] = [round.voter]
        
        if let coop = round.coop {
            voterTeam.append(coop)
        }
        
        if round.voterWon {
            winners = voterTeam
        } else {
            winners = round.game?.players.filter { !voterTeam.contains($0) } ?? []
        }
        
        return winners.map { $0.name }.joined(separator: " & ")
    }
}

#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    return RoundDetailPopup(round: game.rounds.first!, dismiss: {}, edit: {})
}
