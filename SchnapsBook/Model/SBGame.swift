import Foundation
import SwiftData

@Model
final class SBGame: ObservableObject {
    var id: UUID
    var name: String
    var date: Date
    var players: [SBPlayer]
    var playerToVote: SBPlayer?
    var rounds: [SBGameRound]
    
    init(name: String, date: Date, players: [SBPlayer], playerToVote: SBPlayer, rounds: [SBGameRound] = []) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.players = players
        self.playerToVote = playerToVote
        self.rounds = rounds
    }
}

extension SBGame {
     static func randomName(length: Int = 6) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func randomDate2024() -> Date {
        let year = 2024
        let month = Int.random(in: 1...12)

        // Get the number of days in the selected month (Leap year considered for February)
        let daysInMonth: [Int: Int] = [
            1: 31, 2: 29, 3: 31, 4: 30, 5: 31, 6: 30,
            7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31
        ]

        let day = Int.random(in: 1...daysInMonth[month]!)

        // Create the date using DateComponents
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return Calendar.current.date(from: components) ?? Date() // Return generated date or fallback to current date
    }
    
    static func mockGame(modelContext: ModelContext) -> SBGame {
        let voter = SBPlayer.mock(modelContext: modelContext)
        let players = [SBPlayer.mock(modelContext: modelContext), voter, SBPlayer.mock(modelContext: modelContext), SBPlayer.mock(modelContext: modelContext)]
        return SBGame(name: randomName(), date: randomDate2024(), players: players, playerToVote: voter)
    }
    static func mockGames(modelContext: ModelContext) -> [SBGame] {
        [
            mockGame(modelContext: modelContext),
            mockGame(modelContext: modelContext),
            mockGame(modelContext: modelContext)
        ]
    }
}


