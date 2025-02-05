import Foundation
import SwiftData

@Model
final class SBSchnapsBook {
    var games: [SBGame]
    
    init(games: [SBGame]) {
        self.games = games
    }
}
