import Foundation
import SwiftUI

@Observable class SBRoundEntryViewModel {
    var game: SBGame
    var round: SBGameRound?
    
    
    var isEditing: Bool {
        round != nil
    }
    
    init(roundToEdit: SBGameRound? = nil , game: SBGame) {
        self.game = game
        self.round = roundToEdit
    }
    
    func addRound() {
        
    }
    
    func editRound(round: SBGameRound) {
        
    }
}

/*
 public var viewModel: SchnapsGameViewModel
 public var voter: String
 public var roundNumber: Int
 
 @State private var voterWon: Bool = true
 @State private var gameType: SBGameType = .normal
 @State private var cheaterSwitch: Bool = false
 @State private var cheater: UUID = UUID.zero
 @State private var teammate: Teammate = Teammate.noTeammates
 @State private var water: Bool = false
 @State private var kontra: SBKontra = .normal
 */
