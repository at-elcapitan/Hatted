//
//  RoleSetup.swift
//  Hatted
//
//  Created by ElCapitan on 04.10.2026.
//

import SwiftUI
import SwiftData

struct RoleSetup: View {
    @Environment(\.modelContext) private var modelContext
    var players: [GamePlayer]
    
    @State var currentPlayerSelected = 0
    
    var currentPlayer: GamePlayer {
        return players[currentPlayerSelected]
    }
    
    private var civDisabled: Bool {
       if players.filter({ $0.role == .civilian }).count > 5 {
           return true
       }
       
       return false
    }
    
    private var mafiaDisabled: Bool {
       if players.filter({ $0.role == .mafia }).count > 1 {
           return true
       }
       
       return false
    }
    
    private var donDisabled: Bool {
       if players.filter({ $0.role == .don }).count > 0 {
           return true
       }
       
       return false
    }
    
    private var sheriffDisabled: Bool {
       if players.filter({ $0.role == .sheriff }).count > 0 {
           return true
       }
       
       return false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                PlayerCircle(
                    playerPosition: currentPlayer.playerPosition,
                    role: currentPlayer.role,
                    showColor: true
                )
                Text(currentPlayer.playerName)
                    .font(.system(size: 20, weight: .bold))
            }
            
            Divider()
                .padding(.horizontal, 10)
            
            HStack {
                Button(action: {
                    setRole(role: .civilian)
                }) {
                    HStack {
                        Image(systemName: "person.fill")
                    }
                    .frame(width: 70, height: 70)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(.interfaceMafiaCiv)
                    )
                }
                .buttonStyle(.plain)
                .disabled(civDisabled)
                
                Spacer()
                
                Button(action: {
                    setRole(role: .sheriff)
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                    }
                    .frame(width: 70, height: 70)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(.interfaceMafiaCiv)
                    )
                }
                .buttonStyle(.plain)
                .disabled(sheriffDisabled)
                
                Spacer()
                
                Button(action: {
                    setRole(role: .mafia)
                }) {
                    HStack {
                        Image(systemName: "person.fill")
                    }
                    .frame(width: 70, height: 70)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(.interfaceMafiaMaf)
                    )
                }
                .buttonStyle(.plain)
                .disabled(mafiaDisabled)
                
                Spacer()
                
                Button(action: {
                    setRole(role: .don)
                }) {
                    HStack {
                        Image(systemName: "crown.fill")
                    }
                    .frame(width: 70, height: 70)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(.interfaceMafiaMaf)
                    )
                }
                .buttonStyle(.plain)
                .disabled(donDisabled)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    prev()
                }) {
                    HStack {
                        Image(systemName: "arrowshape.left.fill")
                        Text("Prev")
                    }
                    .frame(width: 140, height: 60)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(.interfaceBlack.opacity(0.7))
                    )
                }
                .buttonStyle(.plain)
                .disabled(currentPlayerSelected == 0)
                
                Spacer()
                
                Button(action: {
                    save()
                }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrowshape.right.fill")
                    }
                    .frame(width: 140, height: 60)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(.interfaceBlack.opacity(0.7))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(
            RoundedRectangle(
                cornerRadius: 40,
                style: .continuous
            )
            .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal)
    }
    
    func prev() {
        if currentPlayerSelected != 0 {
            currentPlayerSelected -= 1
        }
    }
    
    func setRole(role: Role) {
        currentPlayer.role = role
    }
    
    func save() {
        if currentPlayerSelected != 9 {
            currentPlayerSelected += 1
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save player: \(error)")
        }
    }
}
