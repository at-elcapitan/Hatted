//
//  ContentView.swift
//  Hatted
//
//  Created by ElCapitan on 30.09.2026.
//

import SwiftUI
import SwiftData

struct InitialMenu: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var search = ""

    private var filteredItems: [Item] {
        if search.isEmpty {
            return items
        }

        return items.filter {
            $0.timestamp.formatted()
                .localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    if !items.isEmpty {
                        ForEach(filteredItems) { item in
                            NavigationLink {
                                Game(gameId: 1)
                            } label: {
                                GameLink(
                                    gameId: 1,
                                    startTime: item.timestamp
                                )
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .contextMenu {
                                Button(role: .destructive) {
                                    delete(item)
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
    }

    private func addItem() {
        let newItem = Item(timestamp: Date())
        modelContext.insert(newItem)
    }

    private func delete(_ item: Item) {
        withAnimation {
            modelContext.delete(item)
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
    var gameId: Int
    var startTime: Date
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "sun.max.fill")
                .foregroundStyle(.interfaceGold)
                .font(.system(size: 28))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Game #\(gameId)")
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

#Preview {
    InitialMenu()
        .modelContainer(for: Item.self, inMemory: true)
}
