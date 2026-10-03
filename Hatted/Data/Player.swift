//
//  Player.swift
//  Hatted
//
//  Created by ElCapitan on 01.10.2026.
//

import Foundation
import SwiftData

enum Role: Int, Codable, CaseIterable {
    case unset
    case civilian
    case mafia
    case sheriff
    case don
    
    var title: String {
        switch self {
        case .civilian:
            return "Civilian"
        case .mafia:
            return "Mafia"
        case .sheriff:
            return "Sheriff"
        case .don:
            return "Don"
        case .unset:
            return "Unset"
        }
    }
}

enum Reason: Int, Codable {
    case voted
    case removed
    case killed
}

/*@Model
final class Player {
    var uuid: UUID
    var playerName: String
    var playerGamesCount: Int = 0
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \GamePlayer.generalPlayer
    )
    var games: [GamePlayer] = []
    
       
    init(
        uuid: UUID,
        playerName: String,
    ) {
        self.uuid = uuid
        self.playerName = playerName
    }
}*/

@Model
final class GamePlayer {
    var playerName: String
    var game: GameData?
    var role: Role
    var playerPosition: Int
    
    var fouls: UInt8 = 0
    var playerRemoveReason: Reason?
    
    @Relationship(
        deleteRule: .nullify,
        inverse: \VotingCandidate.nominator
    )
    var nominations: [VotingCandidate] = []
    
    @Relationship(
        deleteRule: .nullify,
        inverse: \VotingCandidate.candidate
    )
    var candidacies: [VotingCandidate] = []
    
    @Relationship(
        deleteRule: .nullify,
        inverse: \DayNightCycle.playerKilled
    )
    var killed: [DayNightCycle] = []
    
    @Relationship(
        deleteRule: .nullify,
        inverse: \DayNightCycle.sheriffCheck
    )
    var checkedBySheriff: [DayNightCycle] = []
    
    @Relationship(
        deleteRule: .nullify,
        inverse: \DayNightCycle.donCheck
    )
    var checkedByDon: [DayNightCycle] = []
    
    init(
        playerName: String,
        game: GameData? = nil,
        role: Role,
        playerPosition: Int
    ) {
        self.playerName = playerName
        self.game = game
        self.role = role
        self.playerPosition = playerPosition
    }
}
