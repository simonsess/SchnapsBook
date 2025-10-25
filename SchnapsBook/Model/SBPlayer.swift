import Foundation
import SwiftData

@Model
final class SBPlayer {
    var id: UUID
    var name: String
    var lastPlayed: Date?
    var isDeleted: Bool = false
    @Relationship(inverse: \SBGame.players)
    var games: [SBGame]
    
    init(id: UUID, name: String, lastPlayed: Date? = nil, score: Int = 0, games: [SBGame] = []) {
        self.id = id
        self.name = name
        self.lastPlayed = lastPlayed
        self.games = games
    }
}

extension SBPlayer {
    static func mockPlayers() -> [SBPlayer] {
        [
            SBPlayer(id: UUID(), name: "Adam"),
            SBPlayer(id: UUID(), name: "Majo"),
            SBPlayer(id: UUID(), name: "Peto"),
            SBPlayer(id: UUID(), name: "Fero"),
            SBPlayer(id: UUID(), name: "Jano"),
            SBPlayer(id: UUID(), name: "Zofia"),
            SBPlayer(id: UUID(), name: "Klement")
        ]
    }
}

extension SBPlayer {
    static func mock(id: UUID = UUID(), postFix: String = "", modelContext: ModelContext) -> SBPlayer {
        let firstName: [String] = ["John", "Jack", "Steve", "Freddie"]
        let lastName: [String] = ["Doe", "Williwms", "Black", "Swift"]
        
        let name = "\(firstName[Int.random(in: 0...3)]) \(lastName[Int.random(in: 0...3)]) \(postFix)"
        return SBPlayer(id: id, name: name, lastPlayed: Date() - 4, score: 0)
    }
}
