//
//  CoinCapTrackerApp.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI

@main
struct CoinCapTrackerApp: App {
    
    @AppStorage("selectedTheme") var selectedTheme: Int = 0
    
    let databaseService = DatabaseService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, databaseService.container.viewContext)
            
                .onAppear {
                    
                    applySelectedTheme()
                    
                    //обновляем БД по таймеру
                    
                    Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                        
                        
                        let coins = DatabaseService.shared.getAllCoins()
                        
                        // строка дла получения данных по id монет
                        var urlString = "?action=items&id=";
                        let ids = coins.map { String($0.id) }
                        urlString += "[" + ids.joined(separator: ",") + "]"
                        
                        print("urlString", urlString)
                        
                        NetworkService.shared.loadCoinData(urlString) { coinDataArray, error in
                            
                            if let error = error {
                                
                            } else if let coinDataArray = coinDataArray {
                                
                                withAnimation {
                                    // Если данные получены успешно, обноаляем их в БД
                                    for coinData in coinDataArray {
                                        databaseService.addCoin(data: coinData)
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }
            
            
        }
    }
    
    private func applySelectedTheme() {
        
        switch selectedTheme {
        case 0:
            AppTheme.system.apply()
        case 1:
            AppTheme.light.apply()
        case 2:
            AppTheme.dark.apply()
        default:
            break
        }
    }
    
}
