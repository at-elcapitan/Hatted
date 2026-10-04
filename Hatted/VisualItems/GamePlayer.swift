//
//  GamePlayer.swift
//  Hatted
//
//  Created by ElCapitan on 04.10.2026.
//

import SwiftUI

struct DraftPlayerCard: View {
    @Binding var player: GamePlayerDraft
    
    var body: some View {
        HStack(spacing: 20) {
            PlayerCircle(
                playerPosition: player.position,
                role: player.role,
                showColor: true
            )
            
            TextField(
                "Player name",
                text: $player.name
            )
            .autocorrectionDisabled()
            .font(.system(size: 16, weight: .bold))
        }
        .padding(2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PlayerCard: View {
    @Bindable var player: GamePlayer
    
    var buttonDisabled: Bool {
        if player.fouls > 3 {
            return true
        }
        
        return false
    }
    
    var secondaryText: String {
        if (player.playerRemoved) {
            return "\(player.role.title) · Removed"
        }
        
        return "\(player.role.title)"
    }
    
    var body: some View {
        HStack(spacing: 20) {
            PlayerCircle(
                playerPosition: player.playerPosition,
                role: player.role,
                showColor: true
            )
            
            VStack(alignment: .leading) {
                Text(player.playerName)
                    .font(.system(size: 16, weight: .bold))
                
                Text(secondaryText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
            
            Button(action: addFoul) {
                Text("\(player.fouls)")
                Image(systemName: "exclamationmark.triangle.fill")
            }
            .buttonStyle(.glass)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .disabled(buttonDisabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(player.playerRemoved ? 0.7 : 1.0)
        .animation(
            .easeInOut(duration: 0.3),
            value: player.playerRemoved
        )
    }
        
    private func addFoul() {
        player.fouls += 1
    }
}
