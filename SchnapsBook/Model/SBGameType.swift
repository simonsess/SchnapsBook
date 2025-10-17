import Foundation

enum SBGameType: Codable {
    case basic(with33: Bool), six, twelve, quietDurch, durch, notPlaying, cheat
    
    var points: Int {
        switch self {
        case .basic(let with33):
            2 * (with33 ? 1 : 2)
        case .notPlaying:
            4
        case .six:
            6
        case .twelve:
            12
        case .quietDurch:
            18
        case .durch:
            36
        case .cheat:
            4
        }
    }
}

enum SBWater: Codable {
    case with, without
}

enum SBKontra: Codable {
    case kontra, re, tuti, boty
    
    var value: Int {
        switch self {
        case .kontra:
            2
        case .re:
            4
        case .tuti:
            8
        case .boty:
            16
        }
    }
}
