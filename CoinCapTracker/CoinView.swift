//
//  TestView.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//
import SwiftUI
import CoreData

struct CoinView: View {
    
    
    //    @Binding var titleOn: Bool // из задачи 2
    @AppStorage("titleOn") var titleOn = true
    
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var dataAdded = false
    
    var coins: FetchedResults<CoinEntity>
    
    var body: some View {
        
        NavigationView {
            if !coins.isEmpty {
                List {
                    ForEach(coins, id: \.self) { coin in
                        NavigationLink(destination: CoinDetails(coin: coin)) {
                            CoinRow(coin: coin)
                            //                        Text("\(coin.currency)")
                        }
                    }
                }
                .navigationTitle(titleOn ? "Монеты":"")
            } else {
                Text("Монеты пока не добавлены, перейдите в натройки что бы добавить монтеы")
                    .multilineTextAlignment(.center)
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
}


//#Preview {
//    CoinView()
//}
