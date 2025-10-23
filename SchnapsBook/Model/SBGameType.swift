import Foundation

enum SBGameType: CaseIterable, Codable, Hashable, Identifiable {
    var id: String { name }
    
//    static var allCases: [SBGameType] {
//        return [.noWater, .normal, .noTrick, .twelve, .allTricks, .durch]
//    }
    
    case noWater, normal, noTrick, twelve, allTricks, durch
    
    var points: Int {
        switch self {
        case .normal:
            2
        case .noWater:
            4
        case .noTrick:
            6
        case .twelve:
            12
        case .allTricks:
            18
        case .durch:
            36
        }
    }
    var name: String {
        "(\(self.points)) \(text)"
    }
    private var text: String {
        switch self {
        case .noWater:
            "no water"
        case .normal:
            "normal game"
        case .noTrick:
            "No trick - not called"
        case .twelve:
            "No trick - called"
        case .allTricks:
            "Durch - not called"
        case .durch:
            "Durch - called"
        }
    }
}

enum SBKontra: CaseIterable, Codable, Hashable, Identifiable {
    case normal, kontra, re, tuti, boty
    
    var id: SBKontra { self }
    var displayName: String {
        switch self {
        case .normal:
            "no kontra"
        case .kontra:
            "kontra"
        case .re:
            "re"
        case .tuti:
            "tuti"
        case .boty:
            "boty"
        }
    }
    var value: Int {
        switch self {
        case .normal:
            1
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
