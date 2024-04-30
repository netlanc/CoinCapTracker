//
//  TestRow.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI

struct CoinRow: View {
    
    var coin: CoinEntity
    
    @State private var coinImage: UIImage? // Состояние для хранения загруженного изображения
    
    var body: some View {
        HStack {
            
            if let coinImagePath = coin.imagePath,
               let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(coinImagePath),
               let imageData = try? Data(contentsOf: imageURL),
               let coinImage = UIImage(data: imageData) {
                Image(uiImage: coinImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .padding()
            } else {
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
