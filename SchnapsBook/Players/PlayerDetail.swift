import SwiftUI

struct PlayerDetail: View {
    var player: SBPlayer
    var body: some View {
        Text("info about : \(player.name)")
    }
}

#Preview {
    PlayerDetail(player: SBPlayer(id: UUID(), name: "Kral ja prvni"))
}
