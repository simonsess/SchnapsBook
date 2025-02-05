import Foundation
import SwiftData

class SchnapsViewModel: ObservableObject {
    public var players: [SBPlayer] = []
    public var games: [SBGame] = []
    
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
//        fetchGames()
//        fetchPlayers()
    }
    
    private func fetchPlayers() {
        let fetchDescriptor = FetchDescriptor<SBPlayer>()
        do {
            players = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch players: \(error)")
        }
    }
    
    private func fetchGames() {
        let fetchDescriptor = FetchDescriptor<SBGame>()
        do {
            games = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch players: \(error)")
        }
    }
}
