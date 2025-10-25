import SwiftUI
import SwiftData

struct PlayersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<SBPlayer> { !$0.isDeleted })  private var players: [SBPlayer]
    @State private var showNewPlayerModal: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(players) { player in
                    NavigationLink {
                        PlayerDetail(player: player)
                    } label: {
                        HStack {
                            Text("\(player.name)")
                        }
                    }
                }
                .onDelete(perform: deletePlayer)
                .foregroundStyle(Color.foregroundSecondary)
                .listRowBackground(Color.backgroundSecondary)
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showNewPlayerModal = true
                    }, label: {
                        Label("Add player", systemImage: "plus")
                    })
                }
            }
            .navigationTitle("Players")
        }  detail: {
            Text("Select an item")
        }
        .fullScreenCover(isPresented: $showNewPlayerModal) {
            NewPlayerView()
        }
    }
    
    private func deletePlayer(offsets: IndexSet) {
        //TODO: confirm delete
        withAnimation {
            for index in offsets {
                players[index].isDeleted = true
            }
        }
    }
}

///Preview
extension PlayersView {
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
    PlayersView()
        .modelContainer(PlayersView.preview)
}
