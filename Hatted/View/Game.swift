//
//  Game.swift
//  Hatted
//
//  Created by ElCapitan on 30.09.2026.
//

import SwiftUI
import SwiftData

struct Game: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    let gameId: Int;

    var body: some View {
        Text("A")
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    Game(gameId: 1)
        .modelContainer(for: Item.self, inMemory: true)
}
