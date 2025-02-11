import SwiftUI
import SwiftData

struct GameCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var players: [SBPlayer]
    @State private var selectedPlayers: [UUID] = []
    @State private var gameName: String = "gggyyyeerr"
    
    @Binding var navigationPath: NavigationPath
    
    var canCreate: Bool {
        selectedPlayers.count == 4 && !gameName.isEmpty
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Name")) {
                        TextField("Enter session name", text: $gameName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Section(header: Text("Select 4 Players")) {
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
                                    } else if selectedPlayers.contains(player.id) {
                                        if let order = selectedPlayers.firstIndex(where: { $0 == player.id }) {
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
                }
                Spacer()
                Button(action: createGame) {
                    Text("Create")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!canCreate ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!canCreate)
                .padding()
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderless)
                .foregroundColor(.red)
                .padding()
            }
            .navigationTitle("New Game")
        }
    }
    
    private func toggleSelection(_ player: SBPlayer) {
        guard !selectedPlayers.contains(player.id) else {
            selectedPlayers.removeAll(where: { $0 == player.id })
            return
        }
        guard selectedPlayers.count < 4 else {
            return
        }
        selectedPlayers.append(player.id)
    }
    
    private func createGame() {
        guard let voter = players.first(where: {$0.id == selectedPlayers[0]}) else {
            //error toast
            return
        }
        let selected = players.filter({selectedPlayers.contains($0.id)})
        let newGame = SBGame(name: gameName, date: Date(), players: [], playerToVote: voter)
        newGame.players = selected
        modelContext.insert(newGame)
        dismiss()
        navigationPath.append(newGame)
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
    GameCreationView(navigationPath: Binding(get: {NavigationPath()}, set: {_ in }))
        .modelContainer(GameCreationView.preview)
}
