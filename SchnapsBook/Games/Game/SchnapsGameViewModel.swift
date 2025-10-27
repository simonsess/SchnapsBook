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

class SchnapsGameViewModel: ObservableObject {
    private var context: ModelContext
    private var playerScore: [UUID: Int] = [:]
    private var playerOrder: [Int: UUID] = [:]
    private let gameId: UUID
    public var game: SBGame?
    
    @Published var gameName: String = ""
    @Published var scoreRounds: [Int: [UUID: Int]] = [:]
    
    private var voterIndex: Int = 0
    
    var sortedPlayers: [SBPlayer] {
        game?.players.sorted(byOrder: playerOrder) ?? []
    }
    
    var newRoundVoter: String {
        game?.playerToVote.name ?? "Unknown"
    }
    
    var gamePlayersSet: [Teammate] {
        var coopPlayers: [Teammate] = [Teammate.noTeammates]
        for player in sortedPlayers {
            coopPlayers.append(Teammate(id: player.id, name: player.name))
        }
        return coopPlayers
    }
    
    var coopPlayersSet: [Teammate] {
        var players = gamePlayersSet
        guard let game else {
            return players
        }
        players.removeAll(where: { $0.id == game.playerToVote.id })
        return players
    }
    
    func playerName(for id: UUID) -> String {
        game?.players.first(where: { $0.id == id })?.name ?? "notFound"
    }
    
    func playerFromId(id: UUID) -> SBPlayer? {
        guard id != UUID.zero else {
            return nil
        }
        return game?.players.first(where: { $0.id == id })
    }
    
    var newRoundNumber: Int? {
        game?.rounds.count
    }
    

    init(gameId: UUID, context: ModelContext) {
        self.context = context
        self.gameId = gameId
    }
    
    public func isPLayerVoter(round: SBGameRound?, playerRank: Int) -> Bool {
        guard let round else {
            return false
        }
        return round.voter == sortedPlayers[playerRank]
    }
    
    public func isPlayerVoterTeam(round: SBGameRound?, playerRank: Int) -> Bool {
        guard let round else {
            return false
        }
        let player = sortedPlayers[playerRank]
        return player == round.voter || player == round.coop
    }
    
    public func round(index: Int) -> SBGameRound? {
        game?.rounds.first(where: { $0.order == index })
    }
    
    public func isPlayerInWinningTeam(round: SBGameRound?, playerRank: Int) -> Bool {
        isPlayerVoterTeam(round: round, playerRank: playerRank) ^ (round?.voterWon ?? false)
    }
    
    public func cellBackground(in round: SBGameRound?, for playerRank: Int) -> Color {
        let player = sortedPlayers[playerRank]
        guard let round else {
            return .clear
        }
        guard round.cheater == nil else {
            return round.cheater == player ? .backgroundError : .clear
        }
        return isPlayerInWinningTeam(round: round, playerRank: playerRank) ? .backgroundWarning : .clear
    }
    
    public func addRound(round: SBGameRound) {
        guard let game else {
            return
        }
        game.rounds.append(round)
        processNewRound(round: round)
        try? context.save()
    }
    
    public func processRounds() {
        for i in 0..<(game?.rounds.count ?? 0) {
            guard let round = game?.rounds.sorted(by: { $0.order < $1.order })[i] else {
                continue
            }
            processNewRound(round: round)
        }
    }
    
    private func processNewRound(round: SBGameRound) {
        sortedPlayers.forEach({ player in
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
        game?.playerToVote = sortedPlayers[voterIndex]
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
    
    @MainActor
    public func fetchGameData() async {
        let descriptor = FetchDescriptor<SBGame>(
                predicate: #Predicate { $0.id == gameId }
            )
        guard let game = try? context.fetch(descriptor).first else {
            return
        }
        game.players.forEach({
            playerScore[$0.id] = 0
        })
        playerOrder = game.playerOrder
        self.game = game
        gameName = game.name
        
        processRounds()
    }
}

