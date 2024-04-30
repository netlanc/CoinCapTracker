//
//  Data.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//

import SwiftUI
import UIKit

struct Post: Identifiable {
    var id = UUID() // Уникальный идентификатор
    var title: String
    var description: String
    var image: Image
}

let posts: [Post] = [
    Post(title: "Заголовок 1", description: "Описание 1", image: Image("image1")),
    Post(title: "Заголовок 2", description: "Описание 2", image: Image("image2")),
    Post(title: "Заголовок 3", description: "Описание 3", image: Image("image3")),
    Post(title: "Заголовок 4", description: "Описание 4", image: Image("image4")),
    Post(title: "Заголовок 5", description: "Описание 5", image: Image("image5")),
]

struct CoinData: Hashable {
    let id: Int
    let name: String
    let code: String
    let dateUpdate: Date
    let currency: Double
    let p1d: Double
    let p1h: Double
    let p7d: Double
    let p30d: Double
    let p90d: Double
    let mk: Double
    let imagePath: String
    let imageUrl: String
}

enum AppTheme {
    case system
    case light
    case dark

    func apply() {
        switch self {
        case .system:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
        case .light:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        case .dark:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
