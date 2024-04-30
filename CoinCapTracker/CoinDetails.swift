//
//  TestDetails.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI

struct CoinDetails: View {
    @State private var coinImage: UIImage?
    @State private var isLoadingImage = false 
    
    @FetchRequest(entity: CoinEntity.entity(), sortDescriptors: []) var coins: FetchedResults<CoinEntity>
    var coin: CoinEntity
    
    var body: some View {
        ScrollView {
            
            HStack {
                
                Spacer()
                
                if let coinImagePath = coin.imagePath,
                   let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(coinImagePath),
                   let imageData = try? Data(contentsOf: imageURL),
                   let coinImage = UIImage(data: imageData) {
                    Image(uiImage: coinImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .padding()
                } else {
                    Image(systemName: "circle.dotted.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 72, height: 72)
                        .padding()
                }
                
                Spacer()
                
                VStack {
                    
                    Text(coin.code!)
                        .font(.title)
                        .padding(.bottom, 8)
                    
                    Text(coin.name!)
                        .font(.title2)
                        .padding(.bottom, 8)
                    
                }
                
                
                Spacer()
                
            }
    
            VStack {
                Text((coin.currency != 0) ? "$ \(coin.currency)":"-")
                    .font(.largeTitle)
                    .lineLimit(nil)
                    .padding(.top, 16)
                    .padding(.bottom, 0)
                Text(dateFormatter.string(from: coin.dateUpdate!))
                    .font(.subheadline)
                    .padding(.bottom, 16)
                
                Spacer()
            }
            
            HStack {
                Text("Изменения стоимости в % за")
                    .font(.title2)
                    .padding()
            }
            
            HStack {
                
                VStack {
                    
                    Text("час")
                        .font(.subheadline)
                    Text("\(coin.p1h)")
                        .font(.subheadline)
                        .foregroundColor(textColor(for: coin.p1h))
                }
                
                VStack {
                    
                    Text("день")
                        .font(.subheadline)
                    Text("\(coin.p1d)")
                        .font(.subheadline)
                        .foregroundColor(textColor(for: coin.p1d))
                }
                
                VStack {
                    
                    Text("неделю")
                        .font(.subheadline)
                    Text("\(coin.p7d)")
                        .font(.subheadline)
                        .foregroundColor(textColor(for: coin.p7d))
                }
                
            }
            .padding(.bottom, 16)
            
            HStack {
                
                VStack {
                    
                    Text("месяц")
                        .font(.subheadline)
                    Text("\(coin.p30d)")
                        .font(.subheadline)
                        .foregroundColor(textColor(for: coin.p30d))
                }
                
                VStack {
                    
                    Text("3 месяца")
                        .font(.subheadline)
                    Text("\(coin.p90d)")
                        .font(.subheadline)
                        .foregroundColor(textColor(for: coin.p90d))
                }
            }
            
            
        }
//        .toolbar {
//            ToolbarItem {
//                Button(action: downloadImage) {
//                    Image(systemName: "arrow.down.to.line.compact")
//                }
//            }
//        }
        .navigationTitle(coin.name!)
        .onAppear {
            loadImage(from: coin)
        }
    }
    
    private func textColor(for value: Double) -> Color {
        value > 0 ? .green:(value == 0 ? .black:.red)
    }
    
    
    private func loadImage(from coin: CoinEntity) {
        
        if let coinImagePath = coin.imagePath {
            let fileManager = FileManager.default
            let imageURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(coinImagePath)
            if let imageURL = imageURL, let coinImage = UIImage(contentsOfFile: imageURL.path) {
                // Если изображение успешно загружено из imagePath, обновляем coinImage
                self.coinImage = coinImage
                isLoadingImage = false
            }
        }
    }
    
//    private func downloadImage() {
//        guard let imageUrlString = coin.imageUrl, let imageUrl = URL(string: imageUrlString) else {
//            // Обработка ошибки некорректного URL
//            print("Invalid image URL")
//            return
//        }
//        
//        NetworkService.shared.loadImage(from: imageUrl) { result in
//            switch result {
//            case .success(let imageDataString):
//                // Преобразование base64 строки в данные изображения
//                if let imageData = Data(base64Encoded: imageDataString) {
//                    // Получение директории для сохранения изображения
//                    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//                        // Обработка ошибки получения директории
//                        print("Error getting documents directory")
//                        return
//                    }
//                    
//                    // Создание имени файла с использованием coin.id
//                    let fileName = "\(coin.id).png"
//                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
//                    
//                    do {
//                        // Запись данных изображения в файл
//                        try imageData.write(to: fileURL)
//                        
//                        // Возврат пути к сохраненному файлу
//                        print("Image saved at: \(fileURL)")
//                        
//                        let relativePath = fileURL.lastPathComponent
//                        
//                        print("relativePath : \(relativePath)")
//                        
//                        DatabaseService.shared.updateCoinImagePath(for: coin.id, with: relativePath)
//                    } catch {
//                        // Обработка ошибки записи данных в файл
//                        print("Error saving image: \(error)")
//                    }
//                } else {
//                    // Обработка ошибки преобразования base64 строки в данные
//                    print("Invalid base64 image data")
//                }
//            case .failure(let error):
//                // Обработка ошибки загрузки изображения
//                print("Error loading image: \(error)")
//            }
//        }
//    }
    
// Метод для вывода изображения по URL
//     private func loadImage(from urlString: String?) {
//         guard let urlString = urlString, let url = URL(string: urlString) else { return }
//
//         // Устанавливаем состояние isLoadingImage в true перед началом загрузки
//         isLoadingImage = true
//
//         URLSession.shared.dataTask(with: url) { data, _, error in
//             if let data = data, let image = UIImage(data: data) {
//                 DispatchQueue.main.async {
//                     coinImage = image // Обновляем состояние с загруженным изображением
//                     isLoadingImage = false // Устанавливаем isLoadingImage в false после загрузки
//                 }
//             } else if let error = error {
//                 print("Error loading image: \(error)")
//                 isLoadingImage = false // Устанавливаем isLoadingImage в false в случае ошибки загрузки
//             }
//         }.resume()
//     }
}

