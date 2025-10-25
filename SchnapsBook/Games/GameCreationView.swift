import SwiftUI
import SwiftData

struct GameCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var players: [SBPlayer]
    @State private var selectedPlayers: [Int: UUID] = [:]
    @State private var gameName: String = Date().ISO8601Format()
    
    @Binding var createdGame: SBGame?
    
    var canCreate: Bool {
        selectedPlayers.count == 4 && !gameName.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(content: {
                        TextField("Enter session name", text: $gameName)
                            .backgroundStyle(Color.backgroundSecondary)
                            .foregroundStyle(Color.foregroundPrimary)
                    }, header: {
                        Text("Name")
                            .foregroundStyle(.foregroundSecondary)
                    })
                    .listRowBackground(Color.backgroundSecondary)
                    Section(content: {
                        pLayerList()
                    }, header: {
                        Text("Select 4 Players")
                            .foregroundStyle(.foregroundSecondary)
                    })
                    .listRowBackground(Color.backgroundSecondary)
                }
                .formStyling()
                SBPrimaryButton(action: createGame, title: "Create")
                    .disabledStyling(isDisabled: !canCreate)
                
                SBSecondaryButton(action: { dismiss() }, title: "Dismiss")
            }
            .navigationTitle("New Game")
            .background(Color.backgroundPrimary)
        }
    }
    @ViewBuilder
    private func pLayerList() -> some View {
        List(players, id: \.self) { player in
            HStack {
                Text(player.name)
                Spacer()
                if !selectedPlayers.isEmpty {
                    if selectedPlayers[0] == player.id {
                        Text("Voter")
                            .foregroundStyle(.tertiary)
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if selectedPlayers.contains(value: player.id) {
                        if let order = selectedPlayers.key(for: player.id) {
                            Text("\(order + 1)")
                                .foregroundStyle(.tertiary)
                        }
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                toggleSelection(player)
            }
        }
    }
    
    private func toggleSelection(_ player: SBPlayer) {
        guard !selectedPlayers.contains(value: player.id) else {
            if let (rank, _) = selectedPlayers.first(where: { $0.value == player.id }) {
                selectedPlayers.removeValue(forKey: rank)
            }
            return
        }
        guard selectedPlayers.count < 4 else {
            return
        }
        selectedPlayers.addNewEntry(for: selectedPlayers.count, value: player.id)
    }
    
    private func createGame() {
        guard let voter = players.first(where: {$0.id == selectedPlayers[0]}) else {
            //error toast
            return
        }
        let selected = players.filter({selectedPlayers.contains(value: $0.id)})
        let newGame = SBGame(name: gameName, date: Date(), players: selected, playerToVote: voter, rounds: [], playerOrder: selectedPlayers)
        modelContext.insert(newGame)
        try? modelContext.save()
        createdGame = newGame
        dismiss()
    }
}

///Preview
extension GameCreationView {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: SBPlayer.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        SBPlayer.mockPlayers().forEach({ player in
            container.mainContext.insert(player)
        })
        return container
    }
}

#Preview {
    let game = try! SchnapsGameView.preview.mainContext.fetch(FetchDescriptor<SBGame>()).first!
    let context = GameCreationView.preview
    GameCreationView(createdGame: Binding(get: { game }, set: {_ in }))
        .modelContainer(GameCreationView.preview)
}
