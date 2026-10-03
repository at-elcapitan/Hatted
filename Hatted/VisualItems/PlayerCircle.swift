//
//  PlayerCircle.swift
//  Hatted
//
//  Created by ElCapitan on 02.10.2026.
//

import SwiftUI

struct PlayerCircle: View {
    let playerPosition: Int
    
    @Binding var role: Role
    @Binding var showColor: Bool
    
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
            return .gray
        }
        
        switch role {
        case .don, .mafia:
            return .black
        case .civilian, .sheriff:
            return .interfaceMafiaCiv
        case .unset:
            return .gray
        }
    }
     
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(color)

            Text("\(playerPosition)")
                .foregroundStyle(.white)
                .font(.system(size: 26, weight: .bold))
        }
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
            }
        }
    }
}

#Preview {
    PlayerCircle(
        playerPosition: 10,
        role: .constant(Role.sheriff),
        showColor: .constant(true)
    )
    PlayerCircle(
        playerPosition: 10,
        role: .constant(Role.don),
        showColor: .constant(true)
    )
}
