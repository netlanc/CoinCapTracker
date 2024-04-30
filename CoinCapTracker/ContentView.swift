//
//  ContentView.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CoinEntity.mk, ascending: false)],
        animation: .default//,
//        predicate: NSPredicate(format: "name LIKE %@", "*Bitcoin*"), animation: .default
    )
    
    private var coins: FetchedResults<CoinEntity>
    
//    @State private var titleOn = true // из задачи 2
    
    var body: some View {
        TabView {
        
            CoinView(coins: coins)
                .tabItem {
                    Label("Coins", systemImage: "bitcoinsign.circle")
                }
            
            HelloView()
                .tabItem {
                    Label("Hello", systemImage: "star")
                }
            
//            SettingsView(titleOn: $titleOn)
            SettingsView(coins: coins)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
