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
    @State private var showingCreateModal: Bool = false

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
                                Game()
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
        .glassEffect(
            .regular,
            in: RoundedRectangle(cornerRadius: 20)
        )
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
        .glassEffect(
            .regular,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

struct GamePlayerDraft: Identifiable {
    let id = UUID()
    let position: Int

    var name: String
    var role: Role = .civilian
    
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
    private var civCount: Int {
        draftPlayers.filter { $0.role == .civilian }.count
    }
    private var mafCount: Int {
        draftPlayers.filter { $0.role == .mafia }.count
    }
    private var sherCount: Int {
        draftPlayers.filter {
            $0.role == .sheriff
        }.count
    }
    private var donCount: Int {
        draftPlayers.filter {
            $0.role == .don
        }.count
    }
    private var gameReady: Bool {
        if civCount == 6 && mafCount == 2 &&
            donCount == 1 && sherCount == 1 {
            return true
        }
        
        return false
    }
    private var submitColor: Color {
        if gameReady {
            return .interfaceGold
        }
        
        return .gray
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
                    .padding(.vertical, 10)
                    .autocorrectionDisabled()
                    .font(.system(size: 30, weight: .bold))
                    
                    HStack {
                        statusCard(number: civCount, of: 6, style: .civilian)
                        Spacer()
                        statusCard(number: mafCount, of: 2, style: .mafia)
                        Spacer()
                        statusCard(number: sherCount + donCount, of: 2, style: .active)
                    }
                    
                    HStack {
                        VStack(spacing: 10) {
                            ForEach($draftPlayers) { $draftPlayer in
                                PlayerCard(player: $draftPlayer)
                            }
                        }
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .scrollClipDisabled()
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: discard) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.interfaceGold)
                        }
                    }
                    ToolbarItem(placement: .title) {
                        Text("New Game")
                            .font(.system(size: 18, weight: .bold))
                    }
                    ToolbarItem {
                        Button(action: submitGame) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(submitColor)
                        }
                        .disabled(!gameReady)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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


// MARK: - Status Card
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
            return .white.opacity(0.2)
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
        .foregroundStyle(foreground)
        .frame(width: 110, height: 80)
        .glassEffect(
            .regular
                .tint(style.color),
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

// MARK: - Player Card
struct PlayerCard: View {
    @Binding var player: GamePlayerDraft
    
    var body: some View {
        HStack(spacing: 20) {
            PlayerCircle(
                playerPosition: player.position,
                role: $player.role,
                showColor: .constant(true)
            )
            
            TextField(
                "Player name",
                text: $player.name
            )
            .autocorrectionDisabled()
            .font(.system(size: 16, weight: .bold))
            
            Spacer()
            
            Picker("", selection: $player.role) {
                ForEach(Role.allCases, id: \.self) { role in
                    Text(role.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.interfaceGold)
                        .tag(role)
                }
            }
            .pickerStyle(.menu)
            .tint(.interfaceBlack)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(
            .regular,
            in: RoundedRectangle(cornerRadius: 20)
        )
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
