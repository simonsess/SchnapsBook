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
    
    init(voter: SBPlayer, coop: SBPlayer? = nil, voterWon: Bool, gameType: SBGameType, kontra: SBKontra? = nil, water: SBWater) {
        self.voter = voter
        self.coop = coop
        self.voterWon = voterWon
        self.gameType = gameType
        self.kontra = kontra
        self.water = water
    }
}
