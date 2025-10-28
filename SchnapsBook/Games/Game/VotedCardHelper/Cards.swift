import Foundation
import SwiftUI

enum Suit: CaseIterable {
    case leaves, hearts, bells, acrons
    
    var image: Image {
        switch self {
        case .acrons:
            Image(.acrons)
        case .bells:
            Image(.bells)
        case .hearts:
            Image(.hearts)
        case .leaves:
            Image(.leaves)
        }
    }
}

enum SuitValue: String , CaseIterable {
    case ace, `X`, king, over, under, `IX` 
    
    var title: String {
        return self.rawValue
    }
}

struct Card {
    var suit: Suit
    var suitValue: SuitValue
}
