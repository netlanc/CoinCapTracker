//
//  TestRow.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI

struct CoinRow: View {
    
    @State private var coinImage: UIImage? 

    @FetchRequest(entity: CoinEntity.entity(), sortDescriptors: []) var coins: FetchedResults<CoinEntity>
    var coin: CoinEntity
    
    var body: some View {
        HStack {
            
            if let coinImagePath = coin.imagePath {
                let fileManager = FileManager.default
                let imageURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(coinImagePath)
                if let imageURL = imageURL, let imageData = try? Data(contentsOf: imageURL), let coinImage = UIImage(data: imageData) {
                    // Если изображение успешно загружено из imagePath, отображаем его
                    Image(uiImage: coinImage)
                        .frame(width: 32, height: 32)
                        .padding()
                } else {
                    // Если загрузка изображения из imagePath не удалась, отображаем изображение по умолчанию
                    Image(systemName: "circle.dotted.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .padding()
                }
            } else {
                // Если imagePath отсутствует, отображаем изображение по умолчанию
                Image(systemName: "circle.dotted.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .padding()
                
            }
            
            VStack {
                HStack {
                    Text(coin.name!)
                        .font(.title2)
                    
                    Spacer()
                }
                Spacer()
                HStack {
                    Text(coin.code!)
                        .font(.subheadline)
                    
                    Spacer()
                    
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            Spacer()
            VStack {
                Text((coin.currency != 0) ? "$ \(coin.currency)":"-")
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}

//#Preview {
//    TestRow()
//}
