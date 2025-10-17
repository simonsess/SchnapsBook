import SwiftUI
import SwiftData

struct SchnapsGamesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var games: [SBGame]
    @State private var showNewGameModal: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(games) { game in
                    NavigationLink {
                        SchnapsGameView(gameId: game.id, context: modelContext)
                    } label: {
                        HStack {
                            Text("\(game.name)")
                            Spacer()
                            Text(game.date, format: Date.FormatStyle(date: .numeric, time: .omitted))
                        }
                    }
                }
                .onDelete(perform: deleteGame)
                //TODO: confirm delete
            }
//            .navigationDestination(for: SBGame.self) { game in
//                SchnapsGameView(gameId: game.id, context: modelContext)
//            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showNewGameModal = true
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                }
            }
            .navigationTitle("Schnapser")
        }
        .fullScreenCover(isPresented: $showNewGameModal) {
            GameCreationView(navigationPath: $navigationPath)
        }
        
    }
    
    private func deleteGame(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(games[index])
            }
        }
    }
}

///Preview
extension SchnapsGamesView {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: SBGame.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        SBGame.mockGames(modelContext: container.mainContext).forEach({ game in
            container.mainContext.insert(game)
        })
        return container
    }
}

#Preview {
    SchnapsGamesView()
        .modelContainer(SchnapsGamesView.preview)
}
