//
//  NetworkService.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.coinDataArray
//

import Foundation
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    
    private let baseURL = "https://script.google.com/macros/s/AKfycbwV6XXaAHagfI4j5WMSEkQsXNWC4P8jsG2t6X4heozaPNpjthygnJ-ZzTc6kuJUvyFp/exec"
    
    private init() {}
    
    func loadCoinData(_ urlString: String = "", completion: @escaping ([CoinData]?, Error?) -> Void) {
        
        guard let url = URL(string: baseURL + urlString) else {
            completion(nil, NSError(domain: "Некорректный URL", code: -1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "Нет данных", code: -1, userInfo: nil))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                guard let ok = jsonData?["ok"] as? Bool, ok,
                      let dataDict = jsonData?["data"] as? [String: [String: Any]] else {
                    completion(nil, NSError(domain: "Некорректные данные для формата json", code: -1, userInfo: nil))
                    return
                }
                
                var coinDataArray: [CoinData] = []
                for (_, coinDict) in dataDict {
                    
                    if let coinData = self.parseCoinData(from: coinDict) {
                        coinDataArray.append(coinData)
                    }
                }
                completion(coinDataArray, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func loadImage(from imageURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "Некорректные данные изображения", code: -1, userInfo: nil)))
                return
            }
            
            // Convert the image data to base64 string
            if let imageDataString = image.pngData()?.base64EncodedString() {
                completion(.success(imageDataString))
            } else {
                completion(.failure(NSError(domain: "Не удалось преобразовать данные изображения в строку base64", code: -1, userInfo: nil)))
            }
        }.resume()
    }
    
    private func parseCoinData(from dict: [String: Any]) -> CoinData? {
        
        guard
            let id = dict["id"] as? Int,
            let code = dict["code"] as? String,
            let name = dict["name"] as? String,
            let dateString = dict["dateUpdate"] as? String,
            let dateUpdate = iso8601DateFormatter.date(from: dateString)
        else {
            return nil
        }
        
        let currency = dict["currency"] as? Double ?? 0.0
        let p1d = dict["p1d"] as? Double ?? 0.0
        let p1h = dict["p1h"] as? Double ?? 0.0
        let p7d = dict["p7d"] as? Double ?? 0.0
        let p30d = dict["p30d"] as? Double ?? 0.0
        let p90d = dict["p90d"] as? Double ?? 0.0
        let mk = dict["mk"] as? Double ?? 0.0
        let imageUrl = dict["imageUrl"] as? String ?? ""
        
        let imagePath = "" // dict["imageUrl"] as? String ?? ""
        
        return CoinData(id: id, name: name, code: code, dateUpdate: dateUpdate, currency: currency, p1d: p1d, p1h: p1h, p7d: p7d, p30d: p30d, p90d: p90d, mk: mk, imagePath: imagePath, imageUrl: imageUrl)
    }
    
    
    let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
