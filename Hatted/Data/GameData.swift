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
    case roles
}

@Model
final class VotingCandidate {
    var candidate: GamePlayer
    var nominator: GamePlayer
    var day: DayNightCycle
    var votes: Int8
    var playerWasDeleted: Bool = false

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
    @Attribute(.unique) var id: UUID = UUID()
    var gameName: String
    var gameDate: Date
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \GamePlayer.game
    )
    var players: [GamePlayer] = []
    
    var sortedPlayers: [GamePlayer] {
        players.sorted {
            $0.playerPosition < $1.playerPosition
        }
    }
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \DayNightCycle.game
    )
    var days: [DayNightCycle] = []
    
    var currentDay: Int {
        days.count
    }
    
    var deadPlayers: [GamePlayer] = []

    init(
        gameName: String,
        gameDate: Date,
        players: [GamePlayer] = []
    ) {
        self.gameName = gameName
        self.gameDate = gameDate
        self.players = players
    }
    
    static var preview: GameData {
        let game: GameData = GameData(
            gameName: "Preview Game",
            gameDate: .now
        )
        
        let players: [GamePlayer] = (1...10).map {
            GamePlayer(
                playerName: "Player",
                game: game,
                role: .unset,
                playerPosition: $0
            )
        }
        
        game.players = players
        
        return game
    }
}
