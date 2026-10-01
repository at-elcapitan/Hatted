//
//  Game.swift
//  Hatted
//
//  Created by ElCapitan on 30.09.2026.
//

import Foundation
import SwiftData

@Model
final class DayNightCycle {
    var playerKilled
}

@Model
final class GameData {
    var gameName: String
    var gameDate: Date
    
    var finishReason = {
        
    }

    // var playerName: [PlayerData]
    
    init(timestamp: Date) {
    }
}
