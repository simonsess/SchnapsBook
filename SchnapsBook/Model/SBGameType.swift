import Foundation

enum SBGameType: Codable {
    case basic, six, twelve, quietDurch, durch, notPlaying, Cheat
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
