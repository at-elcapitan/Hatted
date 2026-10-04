//
//  StatusCard.swift
//  Hatted
//
//  Created by ElCapitan on 04.10.2026.
//

import SwiftUI

enum statusCardStyle: Int {
    case civilian
    case mafia
    case active
    
    var text: String {
        switch self {
        case .civilian:
            return "Civilians"
        case .mafia:
            return "Mafia"
        case .active:
            return "Active"
        }
    }
    
    var color: Color {
        switch self {
        case .civilian:
            return .interfaceMafiaCiv.opacity(0.9)
        case .mafia:
            return .interfaceMafiaMaf
        case .active:
            return .interfaceGold.opacity(0.9)
        }
    }
}

struct statusCard: View {
    var number: Int
    let of: Int
    let style: statusCardStyle
    
    var foreground: Color {
        if style == statusCardStyle.active {
            return .interfaceBlack
        }
        
        return .white
    }
    
    var body: some View {
        VStack {
            Text("\(number)/\(of)")
                .font(.system(size: 24, weight: .bold))
            Text(style.text)
                .font(.subheadline)
        }
        .foregroundStyle(.white)
        .frame(width: 110, height: 80)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(style.color)
        }
    }
}
