import Foundation
import SwiftData

@Model
class SBGameRound {
    var voter: SBPlayer
    var coop: SBPlayer?
    var voterWon: Bool
    var gameType: SBGameType
    var kontra: SBKontra?
    var water: SBWater
    var cheater: SBPlayer?
    
    var players: [SBPlayer]
    
    var voterTeam: [SBPlayer] {
        []
    }
    
    var points: Int {
        var points: Int = gameType.points
        if let kontra {
            points *= kontra.value
        }
        return points
    }
    
    init(voter: SBPlayer, coop: SBPlayer? = nil, voterWon: Bool, players: [SBPlayer], gameType: SBGameType, kontra: SBKontra? = nil, water: SBWater, cheater: SBPlayer? = nil) {
        self.voter = voter
        self.coop = coop
        self.voterWon = voterWon
        self.gameType = gameType
        self.kontra = kontra
        self.water = water
        self.cheater = cheater
        self.players = players
    }
}
