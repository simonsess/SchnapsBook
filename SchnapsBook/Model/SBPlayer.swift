import Foundation
import SwiftData

@Model
final class SBPlayer {
    var id: UUID
    var name: String
    var lastPlayed: Date?
    var score: Int
    var isDeleted: Bool = false
    
    init(id: UUID, name: String, lastPlayed: Date? = nil, score: Int = 0) {
        self.id = id
        self.name = name
        self.lastPlayed = lastPlayed
        self.score = score
    }
    
    func resetScore() {
        score = 0
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
    static func mock(modelContext: ModelContext) -> SBPlayer {
        return SBPlayer(id: UUID(), name: "John Doe", lastPlayed: Date() - 4, score: 0)
//        modelContext.insert(player) //Why do we dont need to add player int context?
    }
}
