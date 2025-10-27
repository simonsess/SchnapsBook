import Foundation
import SwiftUI

@Observable class SBRoundEntryViewModel {
    var game: SBGame
    var round: SBGameRound?
    
    
    var isEditing: Bool {
        round != nil
    }
    
    var roundNumber: Int {
        guard let round else {
            return game.rounds.count
        }
        return round.order + 1
    }
    
    var roundVoter: String {
        guard let round else {
            return game.playerToVote.name
        }
        return round.voter.name
    }
    
    var coopPlayer: SBPlayer? {
        playerFromId(id: teammate.id)
    }
    
    var cheaterPlayer: SBPlayer? {
        playerFromId(id: cheater.id)
    }
    
    var voterWon: Bool
    var gameType: SBGameType
    var kontra: SBKontra
    var cheaterSwitch: Bool
    var cheater: Teammate
    var teammate: Teammate
    
    var gamePlayersSet: [Teammate] {
        var coopPlayers: [Teammate] = [Teammate.noTeammates]
        for player in game.sortedPlayers {
            coopPlayers.append(Teammate(id: player.id, name: player.name))
        }
        return coopPlayers
    }
    
    var coopPlayersSet: [Teammate] {
        var players = gamePlayersSet
        var voterId = game.playerToVote.id
        if let roundVoterId = round?.voter.id {
            voterId = roundVoterId
        }
        players.removeAll(where: { $0.id == voterId })
        return players
    }
    
    init(roundToEdit: SBGameRound? = nil , game: SBGame) {
        self.game = game
        self.round = roundToEdit
        
        if let coop = roundToEdit?.coop {
            teammate = Teammate(id: coop.id, name: coop.name)
        } else {
            teammate = .noTeammates
        }
        voterWon = true
        if let roundToEdit {
            voterWon = roundToEdit.voterWon
        }
        
        gameType = .normal
        if let roundToEdit {
            gameType = roundToEdit.gameType
        }
        
        kontra = .normal
        if let roundToEdit {
            kontra = roundToEdit.kontra
        }
        
        cheaterSwitch = roundToEdit?.cheater != nil
        
        if let cheater = roundToEdit?.cheater {
            self.cheater = Teammate(id: cheater.id, name: cheater.name)
        } else {
            cheater = Teammate.noTeammates
        }
    }
    
    private func playerFromId(id: UUID) -> SBPlayer? {
        guard id != UUID.zero else {
            return nil
        }
        return game.players.first(where: { $0.id == id })
    }
    
    func addRound() -> SBGameRound {
        let round = SBGameRound(voter: game.playerToVote, coop: coopPlayer, voterWon: voterWon, gameType: gameType, kontra: kontra, cheater: cheaterPlayer, order: roundNumber)
        game.rounds.append(round)
        return round
    }
    
    func updateRound() {
        guard let round else {
            return
        }
        round.coop = coopPlayer
        round.voterWon = voterWon
        round.gameType = gameType
        round.kontra = kontra
        round.cheater = cheaterPlayer
    }
}
