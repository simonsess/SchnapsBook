import Foundation
import SwiftUI
import SwiftData
import Observation

struct Teammate: Identifiable, Hashable {
    var id: UUID
    var name: String?
}

extension Teammate {
    static var noTeammates: Teammate {
        Teammate(id: UUID.zero, name: nil)
    }
}

@Observable final class SchnapsGameViewModel {
    private var playerScore: [UUID: Int] = [:]
    private var scoreRounds: [Int: [UUID: Int]] = [:]
    var game: SBGame
    
    private var voterIndex: Int = 0
    
    init(game: SBGame) {
        self.game = game
    }
    
    public func scoreForRound(round: Int) -> [UUID: Int]? {
        scoreRounds[round]
    }
    
    public func isPLayerVoter(round: SBGameRound?, playerRank: Int) -> Bool {
        guard let round else {
            return false
        }
        return round.voter == game.sortedPlayers[playerRank]
    }
    
    public func isPlayerVoterTeam(round: SBGameRound?, playerRank: Int) -> Bool {
        guard let round else {
            return false
        }
        let player = game.sortedPlayers[playerRank]
        return player == round.voter || player == round.coop
    }
    
    public func round(index: Int) -> SBGameRound? {
        game.rounds.first(where: { $0.order == index })
    }
    
    public func isPlayerInWinningTeam(round: SBGameRound?, playerRank: Int) -> Bool {
        isPlayerVoterTeam(round: round, playerRank: playerRank) ^ (round?.voterWon ?? false)
    }
    
    public func cellBackground(in round: SBGameRound?, for playerRank: Int) -> Color {
        let player = game.sortedPlayers[playerRank]
        guard let round else {
            return .clear
        }
        guard round.cheater == nil else {
            return round.cheater == player ? .backgroundError : .clear
        }
        return isPlayerInWinningTeam(round: round, playerRank: playerRank) ? .backgroundWarning : .clear
    }
    
    public func addRound(round: SBGameRound) {
        game.rounds.append(round)
        processNewRound(round: round)
    }
    
    public func processRounds() {
        scoreRounds = [:]
        voterIndex = 0
        game.players.forEach({
            playerScore[$0.id] = 0
        })
        for i in 0..<game.rounds.count {
            let round = game.rounds.sorted(by: { $0.order < $1.order })[i]
            processNewRound(round: round)
        }
    }
    
    private func processNewRound(round: SBGameRound) {
        game.sortedPlayers.forEach({ player in
            var score = roundScoreForPlayer(round: round, player: player)
            if let stored = playerScore[player.id] {
                score += stored
            }
            playerScore[player.id] = score
        })
        scoreRounds.appendLast(playerScore)
        setNextPlayerToVote()
    }
    
    private func setNextPlayerToVote() {
        voterIndex = (voterIndex + 1) % 4
        game.playerToVote = game.sortedPlayers[voterIndex]
    }
    
    private func roundScoreForPlayer(round: SBGameRound, player: SBPlayer) -> Int {
        guard round.cheater == nil else {
            return round.gameType.points * round.kontra.value * (round.cheater == player ? -3 : 1)
        }
        var voterTeam: [SBPlayer] = []
        voterTeam.append(round.voter)
        if let coop = round.coop {
            voterTeam.append(coop)
        }
        
        var voterAloneMultiplier = 1
        if voterTeam.count == 1 {
            voterAloneMultiplier = 3
        }
        let playerInVoterTeam = voterTeam.contains(player)
        return
            (round.gameType.points * (playerInVoterTeam ? voterAloneMultiplier : 1)) * round.kontra.value
                *
            (round.voterWon ^ playerInVoterTeam ? 1 : -1)
    }
}

