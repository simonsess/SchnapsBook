import SwiftUI
import SwiftData

struct PlayersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [SBPlayer]
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
                //TODO: confirm delete
            }
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
        withAnimation {
            for index in offsets {
                modelContext.delete(players[index])
            }
        }
    }
}

#Preview {
    PlayersView()
        .modelContainer(for: SBPlayer.self, inMemory: true)
}
