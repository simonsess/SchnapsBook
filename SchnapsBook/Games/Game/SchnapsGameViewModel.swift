import Foundation
import SwiftData
import Observation

class SchnapsGameViewModel: ObservableObject {
    private var context: ModelContext
    private var playerScore: [UUID: Int] = [:]
    private var playerOrder: [Int: UUID] = [:]
    public var rounds: [Int: SBGameRound] = [:]
    public var game: SBGame?
    
    @Published var gameName: String = ""
    @Published var scoreRounds: [Int: [UUID: Int]] = [:]
    
    private var voterIndex: Int = 0
    
    var sortedPlayers: [SBPlayer] {
        game?.players.sorted(byOrder: playerOrder) ?? []
    }
    

    init(gameId: UUID, context: ModelContext) {
        self.context = context
        Task {
            await fetchGameData(id: gameId)
        }
    }
    
    public func isPlayerVoterTeam(round: SBGameRound?, playerRank: Int) -> Bool {
        guard let round else {
            return false
        }
        let player = sortedPlayers[playerRank]
        return player == round.voter || player == round.coop
    }
    
    public func addRound(round: SBGameRound) {
        guard let game else {
            return
        }
        game.rounds.append(SBGameRoundLink(index: game.rounds.count, round: round))
        try? context.save()
        processNewRound(round: round)
    }
    
    public func processRounds(rounds: [SBGameRound]) {
        rounds.forEach({ round in
            processNewRound(round: round)
        })
    }
    
    private func processNewRound(round: SBGameRound) {
        sortedPlayers.forEach({ player in
            var score = roundScoreForPlayer(round: round, player: player)
            if let stored = playerScore[player.id] {
                score += stored
            }
            playerScore[player.id] = score
        })
        voterIndex = (voterIndex + 1) % 4
        print("newVoterIndex: \(voterIndex)")
        let player = sortedPlayers[voterIndex]
        game?.playerToVote = player
        
        scoreRounds.appendLast(playerScore)
    }
    
    func roundScoreForPlayer(round: SBGameRound, player: SBPlayer) -> Int {
        guard round.cheater == nil else {
            return round.gameType.points * (round.cheater == player ? -1 : 1)
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
            (round.gameType.points * (playerInVoterTeam ? voterAloneMultiplier : 1))
                *
            (round.voterWon ^ playerInVoterTeam ? 1 : -1)
    }
    
    @MainActor
    private func fetchGameData(id: UUID) async {
        let descriptor = FetchDescriptor<SBGame>(
                predicate: #Predicate { $0.id == id }
            )
        guard let game = try? context.fetch(descriptor).first else {
            return
        }
        game.players.forEach({
            playerScore[$0.id] = 0
        })
        playerOrder = game.playerOrder
        var roundDict: [Int: SBGameRound] = [:]
        for round in game.rounds {
            roundDict[Int(round.index)] = round.round
        }
        rounds = roundDict
        self.game = game
        
        gameName = game.name
    }
}
