import SwiftUI
import SwiftData

struct SchnapsGamesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var games: [SBGame]
    @State private var showNewGameModal: Bool = false
    @State private var navigationPath = NavigationPath()
    @State private var createdGame: SBGame? = nil
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(games) { game in
                    HStack {
                        Text("\(game.name)")
                            .foregroundStyle(Color.foregroundSecondary)
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(game.date, format: Date.FormatStyle(date: .numeric, time: .omitted))
                            .foregroundStyle(Color.foregroundTertiary)
                            .foregroundStyle(.secondary)
                            .fontWeight(.bold)
                    }
                    .listRowBackground(Color.backgroundSecondary)
                    .onTapGesture {
                        navigationPath.append(game)
                    }
                }
                .onDelete(perform: deleteGame)
                //TODO: confirm delete
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .navigationDestination(for: SBGame.self) { game in
                SchnapsGameView(viewModel: SchnapsGameViewModel(game: game))
                    .toolbar(.hidden, for: .tabBar)
            }
            .navigationDestination(for: SBGame?.self) { game in
                if let game {
                    SchnapsGameView(viewModel: SchnapsGameViewModel(game: game))
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showNewGameModal = true
                        createdGame = nil
                    }, label: {
                        Label("Add Game", systemImage: "plus")
                    })
                }
            }
            .navigationTitle("Schnapser")
        }
        .fullScreenCover(isPresented: $showNewGameModal, onDismiss: {
            guard let createdGame else {
                return
            }
            navigationPath.append(createdGame)
        }) {
            GameCreationView(createdGame: $createdGame)
                .toolbar(.hidden, for: .tabBar)
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
