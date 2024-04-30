//
//  ContentView.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI

struct ContentView: View {
    
//    @State private var titleOn = true // из задачи 2
    
    var body: some View {
        TabView {
            
//            TestView(titleOn: $titleOn)
            CoinView()
                .tabItem {
                    Label("Coins", systemImage: "bitcoinsign.circle")
                }
            
            HelloView()
                .tabItem {
                    Label("Hello", systemImage: "star")
                }
            
//            SettingsView(titleOn: $titleOn)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
