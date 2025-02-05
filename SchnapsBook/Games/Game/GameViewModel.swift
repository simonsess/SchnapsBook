import Foundation
import SwiftData

@Model
class GameViewModel: ObservableObject {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
