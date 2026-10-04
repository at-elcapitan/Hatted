//
//  PlayerCircle.swift
//  Hatted
//
//  Created by ElCapitan on 02.10.2026.
//

import SwiftUI

struct PlayerCircle: View {
    let playerPosition: Int
    
    var role: Role
    var showColor: Bool
    
    var iconName: String {
        switch role {
        case .sheriff:
            return "star.fill"
        case .don:
            return "crown.fill"
        default:
            return "person.crop.circle.badge.exclamationmark"
        }
    }
    
    var color: Color {        
        if !showColor {
            return .gray.opacity(0.9)
        }
        
        switch role {
        case .don, .mafia:
            return .interfaceMafiaMaf
        case .civilian, .sheriff:
            return .interfaceMafiaCiv
        case .unset:
            return .gray.opacity(0.6)
        }
    }
     
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(color)
                .animation(
                    .easeInOut(duration: 0.35),
                    value: color
                )

            Text("\(playerPosition)")
                .foregroundStyle(.white)
                .font(.system(size: 26, weight: .bold))
                .contentTransition(.numericText())
        }
        .animation(.snappy, value: playerPosition)
        .overlay(alignment: .topTrailing) {
            if role == .sheriff || role == .don && showColor {
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 22, height: 22)
                    Image(systemName: iconName)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.interfaceGold)
                }
                .glassEffect(
                    .regular,
                    in: .circle
                )
                .offset(x: 6, y: -6)
                .transition(.scale.combined(with: .opacity))
                .animation(
                    .easeInOut(duration: 0.3),
                    value: role
                )
            }
        }
    }
}

#Preview {
    PlayerCircle(
        playerPosition: 10,
        role: Role.sheriff,
        showColor: true
    )
    PlayerCircle(
        playerPosition: 10,
        role: Role.don,
        showColor: true
    )
    PlayerCircle(
        playerPosition: 10,
        role: Role.unset,
        showColor: true
    )
    PlayerCircle(
        playerPosition: 10,
        role: Role.unset,
        showColor: true
    )
}
