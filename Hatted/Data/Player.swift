//
//  Player.swift
//  Hatted
//
//  Created by ElCapitan on 01.10.2026.
//

import Foundation
import SwiftData

enum Role: Int, Codable {
    case civilian
    case mafia
    case sheriff
    case don
}

enum Reason: Int, Codable {
    case voted
    case removed
}

@Model
final class Player {
    var playerName: String
    var playerPosition: Int8
    var playerRole: Role
    var playerFouls: Int8
    
    var playerResult: Int = 0
    
    init(playerName: String, playerPosition: Int8, playerRole: Role, playerFouls: Int8, playerResult: Int) {
        self.playerName = playerName
        self.playerPosition = playerPosition
        self.playerRole = playerRole
        self.playerFouls = playerFouls
        self.playerResult = playerResult
    }
}
