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
    @Bindable var game: GameData

    var body: some View {
        TabView {
            GameMain(game: game)
            .tabItem {
                Label("Table", systemImage: "circle.grid.3x3.fill")
            }
            
            Group {
                Text("A")
            }
            .tabItem {
                Label("Voting", systemImage: "hand.raised.fill")
            }
            
            Group {
                Text("A")
            }
            .tabItem {
                Label("Best Choice", systemImage: "target")
            }
            
            Group {
                Text("A")
            }
            .tabItem {
                Label("Result", systemImage: "list.bullet")
            }
        }
    }
    
    init(game: GameData) {
        self._game = Bindable(wrappedValue: game)
        
        let tabBarApp = UITabBarAppearance()
        tabBarApp.configureWithDefaultBackground()

        tabBarApp.stackedLayoutAppearance.selected.iconColor = .interfaceGold
        tabBarApp.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.interfaceGold
        ]

        UITabBar.appearance().standardAppearance = tabBarApp
    }
}

#Preview {
    Game(game: .preview)
        .modelContainer(
            for: GameData.self,
            inMemory: true
        )
}
