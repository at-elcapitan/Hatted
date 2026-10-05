//
//  GameMain.swift
//  Hatted
//
//  Created by ElCapitan on 04.10.2026.
//

import SwiftUI
import SwiftData

struct GameMain: View {
    @Bindable var game: GameData
    
    private var mafiaCount: Int {
        game.players.filter({ $0.role == .mafia && !$0.playerRemoved }).count
    }
    
    private var civCount: Int {
        game.players.filter({ $0.role == .civilian && !$0.playerRemoved }).count
    }
    
    private var actCount: Int {
        game.players.filter({ $0.role == .sheriff || $0.role == .don && !$0.playerRemoved }).count
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 15) {
                RoleSetup(players: game.sortedPlayers)
                    .frame(maxWidth: .infinity)
                
                HStack {
                    statusCard(number: civCount, of: 6, style: .civilian)
                    Spacer()
                    statusCard(number: mafiaCount, of: 2, style: .mafia)
                    Spacer()
                    statusCard(number: actCount, of: 2, style: .active)
                }
                .padding(.horizontal, 30)
                
                PlayersList(game: game)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PlayersList: View {
    @Bindable var game: GameData
    
    var body: some View {
        VStack {
            ForEach(game.sortedPlayers) { player in
                PlayerCard(player: player)

                if player.playerPosition != game.players.count {
                    Divider()
                        .padding(.leading, 70)
                }
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(
                cornerRadius: 40,
                style: .continuous
            )
            .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

#Preview {
    GameMain(game: .preview)
        .modelContainer(
            for: GameData.self,
            inMemory: true
        )
}
