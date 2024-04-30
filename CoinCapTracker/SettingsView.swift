//
//  SettingsView.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    //    @Binding var titleOn: Bool // из задачи 2
    @AppStorage("titleOn") var titleOn = true
    
    @State private var notificationsEnabled = true
    @AppStorage("selectedTheme") var selectedTheme = 0
    @State private var sliderValue = 50.0
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CoinEntity.mk, ascending: false)]//,
        //        predicate: NSPredicate(format: "name LIKE %@", "*Bitcoin*"), animation: .default
    )
    
    private var coins: FetchedResults<CoinEntity>
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Уведомления")) {
                    Toggle("Уведомления включены", isOn: $notificationsEnabled)
                }
                
                Section(header: Text("Цветовая схема")) {
                    Text("Включена \(colorScheme == .dark ? "темная" : "светлая") тема")
                    Picker("Тема", selection: $selectedTheme) {
                        Text("Системная").tag(0)
                        Text("Светлая").tag(1)
                        Text("Темная").tag(2)
                    }
                }
                
                Section(header: Text("Громкость")) {
                    Slider(value: $sliderValue, in: 0...100, step: 1)
                }
                
                Section(header: Text("Заголовок списка")) {
                    Toggle("\(titleOn ? "Отключить":"Включить") заголовок списка", isOn: $titleOn)
                }
                
                Section(header: Text("Монеты")) {
                    NavigationLink(destination: SelectCoinsView(coinsExist: coins)) {
                        HStack {
                            Text("Выбрать монеты")
                            
                            Spacer()
                            Text("(\(coins.count))")
                        }
                    }
                }
            }
            .navigationTitle("Настройки")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: selectedTheme) { _ in
            // Обновляем тему в зависимости от выбранной опции
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
    
}

#Preview {
    SettingsView()
}
