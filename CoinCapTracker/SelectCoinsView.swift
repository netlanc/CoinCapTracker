//
//  SelectCoinsView.swift
//  CoinCapTracker
//
//  Created by netlanc on 29.04.2024.
//

import SwiftUI

struct SelectCoinsView: View {
    
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var coins = [CoinData]()
    @State private var selectedCoins = Set<CoinData>()
    
    var coinsExist: FetchedResults<CoinEntity>
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Монеты в БД")) {
                    List {
                        ForEach(coinsExist, id: \.self) { coin in
                            
                            HStack {
                                Button(action: {
                                    if let index = coinsExist.firstIndex(of: coin) {
                                        deleteCoinsExist(at: IndexSet(integer: index))
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                HStack {
                                    Text(coin.name!)
                                    Spacer()
                                    Text((coin.currency != 0) ? "$ \(coin.currency)" : "-")
                                        .fixedSize(horizontal: true, vertical: false)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteCoinsExist(at: indexSet)
                        }
                    }
                }
                
                
                Section(header: Text("Поиск монет")) {
                    HStack {
                        TextField("Введите название монеты", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing, 12)
                            .padding(.vertical, 6)
                        
                        Button(action: fetchData) {
                            Text("Найти")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(6)
                    }
                }
                
                
                Section(header: Text("Найденные монеты")) {
                    if isLoading {
                        ProgressView() // Показать индикатор загрузки, если isLoading == true
                    } else {
                        List(coins, id: \.self) { coin in
                            let id = coin.id
                            if !coinsExist.contains(where: { $0.id == id }) {
                                HStack {
                                    Button(action: {
                                        toggleSelection(for: coin)
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    HStack {
                                        Text("\(coin.name)")
                                        Spacer()
                                        Text((coin.currency != 0) ? "$ \(coin.currency)" : "-")
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarTitle("Список монет", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteCoinsExist(at offsets: IndexSet) {
        for index in offsets {
            let coin = coinsExist[index]
            DatabaseService.shared.deleteCoin(byID: coin.id)
        }
    }
    
    
    private func toggleSelection(for coin: CoinData) {
        
        if let index = coins.firstIndex(of: coin) {
            coins.remove(at: index)
        }
        
        DatabaseService.shared.addCoin(data: coin)
        
        // получить монету по id и скачать ее иконку
        downloadImage(for: coin.id, image: coin.imageUrl)
        
    }
    
    private func fetchData() {
        isLoading = true
        NetworkService.shared.loadCoinData() { [self] coinDataArray, error in
            isLoading = false
            
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else if let coinDataArray = coinDataArray {
                let sortedCoins = coinDataArray.sorted(by: { $0.mk > $1.mk })
                coins = sortedCoins
            }
        }
    }
    
    private func downloadImage(for coinId: Int, image coinUrlString: String) {
        guard let imageUrl = URL(string: coinUrlString) else {
            // Обработка ошибки некорректного URL
            print("Invalid image URL")
            return
        }
        
        NetworkService.shared.loadImage(from: imageUrl) { result in
            switch result {
            case .success(let imageDataString):
                // Преобразование base64 строки в данные изображения
                if let imageData = Data(base64Encoded: imageDataString) {
                    // Получение директории для сохранения изображения
                    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        // Обработка ошибки получения директории
                        print("Error getting documents directory")
                        return
                    }
                    
                    // Создание имени файла с использованием coin.id
                    let fileName = "\(coinId).png"
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    
                    do {
                        // Запись данных изображения в файл
                        try imageData.write(to: fileURL)
                        
                        // Возврат пути к сохраненному файлу
                        print("Image saved at: \(fileURL)")
                        
                        let relativePath = fileURL.lastPathComponent
                        
                        print("relativePath : \(relativePath)")
                        
                        DatabaseService.shared.updateCoinImagePath(for: Int32(coinId), with: relativePath)
                    } catch {
                        // Обработка ошибки записи данных в файл
                        print("Error saving image: \(error)")
                    }
                } else {
                    // Обработка ошибки преобразования base64 строки в данные
                    print("Invalid base64 image data")
                }
            case .failure(let error):
                // Обработка ошибки загрузки изображения
                print("Error loading image: \(error)")
            }
        }
    }
    
}

//#Preview {
//    SelectCoinsView()
//}
