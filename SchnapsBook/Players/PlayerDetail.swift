import SwiftUI
import SwiftData

struct PlayerDetail: View {
    
    @Bindable var player: SBPlayer
    @State var playerName: String = ""
    @State var canSave: Bool = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section(content: {
                    TextField("", text: $player.name)
                }, header: {
                    Text("Player's name")
                        .foregroundStyle(Color.foregroundPrimary)
                })
                .listRowBackground(Color.backgroundSecondary)
                Section(content: {
                    FormTextLabelRow(label: "Games played", value: "\(player.games.count)")
                }, header: {
                    Text("Stats")
                        .foregroundStyle(Color.foregroundPrimary)
                })
                .listRowBackground(Color.backgroundSecondary)
                
            }
            .formStyling()
            .onChange(of: player.name) { oldValue, newValue in
                canSave = newValue != playerName
            }
            SBPrimaryButton(action: {
                try? context.save()
                dismiss()
            }, title: "Submit")
            .disabledStyling(isDisabled: !canSave)
        }
        .background(Color.backgroundPrimary)
        .onAppear() {
            self.playerName = player.name
        }
    }
}

#Preview {
    PlayerDetail(player: SBPlayer(id: UUID.zero, name: "Kral ja prvni"))
}
