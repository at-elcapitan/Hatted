//
//  Game.swift
//  Hatted
//
//  Created by ElCapitan on 30.09.2026.
//

import Foundation
import SwiftData

enum GameState: Int, Codable {
    case day
    case night
    case setup
}

@Model
final class VotingCandidate {
    var candidate: GamePlayer
    var nominator: GamePlayer
    var day: DayNightCycle
    var votes: Int8

    init(
        candidate: GamePlayer,
        nominator: GamePlayer,
        votes: Int8 = 0,
        day: DayNightCycle
    ) {
        self.candidate = candidate
        self.nominator = nominator
        self.votes = votes
        self.day = day
    }
}

@Model
final class DayNightCycle {
    var game: GameData
    var playerKilled: GamePlayer?
    var sheriffCheck: GamePlayer?
    var donCheck: GamePlayer?
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \VotingCandidate.day
    )
    var nominations: [VotingCandidate] = []
    
    var playerWasDeleted: Bool = false
    
    init(
        game: GameData,
        playerKilled: GamePlayer? = nil,
        sheriffCheck: GamePlayer? = nil,
        donCheck: GamePlayer? = nil,
        nominations: [VotingCandidate]
    ) {
        self.game = game
        self.playerKilled = playerKilled
        self.sheriffCheck = sheriffCheck
        self.donCheck = donCheck
        self.nominations = nominations
    }
}

@Model
final class GameData {
    var gameName: String
    var gameDate: Date
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \GamePlayer.game
    )
    var players: [GamePlayer] = []
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \DayNightCycle.game
    )
    var days: [DayNightCycle] = []
    
    var currentDay: Int {
        days.count
    }

    init(
        gameName: String,
        gameDate: Date,
        players: [GamePlayer] = [],
        days: [DayNightCycle] = []
    ) {
        self.gameName = gameName
        self.gameDate = gameDate
        self.players = players
        self.days = days
    }
    
    var alivePlayers: [GamePlayer] {
        players.filter{ $0.playerRemoveReason == nil }
    }
    
    var deadPlayers: [GamePlayer] {
        players.filter { $0.playerRemoveReason != nil }
    }
}
