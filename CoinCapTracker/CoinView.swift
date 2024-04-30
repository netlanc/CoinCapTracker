//
//  TestView.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//
import SwiftUI
import CoreData

struct CoinView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CoinEntity.mk, ascending: false)]//,
        //        predicate: NSPredicate(format: "name LIKE %@", "*Bitcoin*"), animation: .default
    )
    private var coins: FetchedResults<CoinEntity>
    
    //    @Binding var titleOn: Bool // из задачи 2
    @AppStorage("titleOn") var titleOn = true
    
//    @State private var isLoading = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var dataAdded = false
    
    var body: some View {
        
        NavigationView {
            if !coins.isEmpty {
                List(coins, id: \.self) { coin in
                    NavigationLink(destination: CoinDetails(coin: coin)) {
                        CoinRow(coin: coin)
                    }
                    
                }
//                .toolbar {
//                    ToolbarItem {
//                        Button(action: fetchData) {
//                            Image(systemName: "arrow.clockwise")
//                                .rotationEffect(.degrees(isLoading ? 360 : 0))
//                                .animation(isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default)
//                        }
//                        .disabled(isLoading)
//                    }
//                    ToolbarItem {
//                        Button(action: deleteAllCoins) {
//                            Label("Delete All", systemImage: "trash")
//                        }
//                    }
//                }
                .navigationTitle(titleOn ? "Монеты":"")
            } else {
                Text("Монеты пока не добавлены, перейдите в натройки что бы добавить монтеы")
                    .multilineTextAlignment(.center)
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
    }
    
//    private func deleteAllCoins() {
//        DatabaseService.shared.deleteAllCoins()
//    }
    
//    private func fetchData() {
//        
//        var urlString = "?action=items&id=";
//        let ids = coins.map { String($0.id) }
//        urlString += "[" + ids.joined(separator: ",") + "]"
//        
//        
//        print("urlString", urlString)
//        
//        
//        isLoading = true
//        NetworkService.shared.loadCoinData(urlString) { [self] coinDataArray, error in
//            isLoading = false
//            
//            if let error = error {
//                alertMessage = error.localizedDescription
//                showAlert = true
//            } else if let coinDataArray = coinDataArray {
//                for coinData in coinDataArray {
//                    DatabaseService.shared.addCoin(data: coinData)
//                }
//                dataAdded.toggle()
//            }
//        }
//    }
}


//#Preview {
//    CoinView()
//}
