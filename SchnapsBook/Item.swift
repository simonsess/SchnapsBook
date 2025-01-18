//
//  Item.swift
//  SchnapsBook
//
//  Created by Simon Skalicky on 18/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
