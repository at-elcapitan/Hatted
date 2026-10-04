//
//  ContentView.swift
//  Hatted
//
//  Created by ElCapitan on 30.09.2026.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Main Menu
struct InitialMenu: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GameData.gameDate, order: .reverse)
    private var games: [GameData]

    @State private var search: String = ""
    @State private var showingCreateModal: Bool = true

    private var filteredItems: [GameData] {
        guard !search.isEmpty else {
            return games
        }

        return games.filter { game in
            let formattedDate = game.gameDate.formatted(
                date: .abbreviated,
                time: .omitted
            )

            return game.gameName.localizedCaseInsensitiveContains(search)
                || formattedDate.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    if !games.isEmpty {
                        ForEach(filteredItems) { game in
                            NavigationLink {
                                Game(game: game)
                            } label: {
                                GameLink(
                                    gameName: game.gameName,
                                    startTime: game.gameDate
                                )
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .contextMenu {
                                Button(role: .destructive) {
                                    delete(game)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    } else {
                        EmptyGameList(onCreateGame: addItem)
                    }
                }
                .padding()
            }
            .navigationTitle("Mafia")
            .searchable(
                text: $search,
                prompt: "Search"
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addItem) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateModal) {
            CreateGameModal(defaultName: "Game \(games.count + 1)")
        }
    }

    private func addItem() {
        showingCreateModal = true
    }

    private func delete(_ game: GameData) {
        withAnimation {
            modelContext.delete(game)

            do {
                try modelContext.save()
            } catch {
                print("Failed to delete game: \(error)")
            }
        }
    }
}


struct EmptyGameList: View {
    let onCreateGame: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "moon.zzz")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.interfaceGold)

            Text("No games yet")
                .font(.system(size: 28, weight: .bold))

            Text("But you always can create one")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button(action: onCreateGame) {
                Label("Create game", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .tint(.interfaceGold)
            .controlSize(.large)
            .padding(.vertical, 5)
        }
        .multilineTextAlignment(.center)
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}

struct GameLink: View {
    var gameName: String
    var startTime: Date
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "sun.max.fill")
                .foregroundStyle(.interfaceGold)
                .font(.system(size: 28))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(gameName)
                    .bold()
                    .font(.system(size: 20))
                
                Text("Started at \(startTime, format: .dateTime.hour().minute())")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .circular
            )
            .foregroundStyle(.interfaceBlack.opacity(0.05))
        )
    }
}

struct GamePlayerDraft: Identifiable {
    let id = UUID()
    let position: Int

    var name: String
    var role: Role = .unset
    
    init(position: Int, name: String = "") {
        self.position = position
        
        if name.isEmpty {
            self.name = "Player \(position)"
        } else {
            self.name = name
        }
    }
}

// MARK: - Modal
struct CreateGameModal: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var draftPlayers: [GamePlayerDraft] = (1...10).map {
        GamePlayerDraft(position: Int($0))
    }
    
    @State var gameName: String
    
    init(defaultName: String) {
        _gameName = State(initialValue: defaultName)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    TextField(
                        "Game name",
                        text: $gameName
                    )
                    .autocorrectionDisabled()
                    .font(.system(size: 30, weight: .bold))
                    
                    HStack {
                        VStack(spacing: 10) {
                            ForEach($draftPlayers) { $draftPlayer in
                                DraftPlayerCard(player: $draftPlayer)
                                
                                if draftPlayer.position != draftPlayers.count {
                                    Divider()
                                        .padding(.leading, 70)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .scrollClipDisabled()
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: discard) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .title) {
                    Text("New Game")
                        .font(.system(size: 18, weight: .bold))
                }
                ToolbarItem {
                    Button(action: submitGame) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.interfaceGold)
                }
            }
        }
        .presentationBackground(
            Color.interfaceBackground
        )
    }
    
    private func discard() {
        dismiss()
    }
    
    private func submitGame() {
        let name = gameName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        let game = GameData(
            gameName: name,
            gameDate: .now
        )
        
        modelContext.insert(game)
        
        for player in draftPlayers {
            let gamePlayer = GamePlayer(
                playerName: player.name,
                game: game,
                role: player.role,
                playerPosition: player.position
            )
            
            game.players.append(gamePlayer)
            dismiss()
        }
    }
}

#Preview {
    InitialMenu()
        .modelContainer(
            for: [
                GameData.self,
                GamePlayer.self
            ],
            inMemory: true
        )
}
