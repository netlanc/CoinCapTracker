//
//  DatabaseService.swift
//  CoinCapTracker
//
//  Created by netlanc on 26.04.2024.
//
import Foundation
import CoreData


final class DatabaseService {
    static let shared = DatabaseService()
    
    let container: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "CoinsModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Неизвестная ошибка \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        viewContext = container.viewContext
    }
    
    func addCoin(data: CoinData) {
        
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", data.id)
        
        do {
            let existingCoins = try viewContext.fetch(fetchRequest)
            var existingCoin = existingCoins.first
            if existingCoin == nil {
                existingCoin = CoinEntity(context: viewContext)
                existingCoin?.id = Int32(data.id)
                
            }

            existingCoin?.name = data.name
            existingCoin?.code = data.code
            existingCoin?.dateUpdate = data.dateUpdate
            existingCoin?.currency = data.currency
            existingCoin?.p1d = data.p1d
            existingCoin?.p1h = data.p1h
            existingCoin?.p7d = data.p7d
            existingCoin?.p30d = data.p30d
            existingCoin?.p90d = data.p90d
            existingCoin?.mk = data.mk
            existingCoin?.imageUrl = data.imageUrl
            //existingCoin?.imagePath = data.imagePath
            
            try viewContext.save()
            
        } catch {
            print("Ошибка при получении монет: \(error)")
        }
    }
    
    func addCoinEntity(coinEntity: CoinEntity) {
        
           do {
               viewContext.insert(coinEntity)
               try viewContext.save()
               print("Монета добавлена ")
           } catch {
               print("Ошибка при добавлении подключения к базе данных: \(error)")
           }
       }
    
    func updateCoinImagePath(for id: Int32, with imagePath: String) {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let coins = try viewContext.fetch(fetchRequest)
            if let coin = coins.first {
                
                coin.imagePath = imagePath
                
                try viewContext.save()
                print("Путь к изображению с ID \(id)  обновлен")
            } else {
                print("Монета с ID \(id) не найдена")
            }
        } catch {
            print("Ошибка при сохранении изображения: \(error)")
        }
    }
    
    func deleteCoin(byID id: Int32) {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let coins = try viewContext.fetch(fetchRequest)
            if let coin = coins.first {
                
                if let imagePath = coin.imagePath {
                    // Получаем URL для директории Documents в приложении
                    let documentsDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    
                    // Собираем полный путь к файлу изображения
                    let fileURL = documentsDirectoryURL.appendingPathComponent(imagePath)
                    
                    // Удаляем файл из системы
                    do {
                        try FileManager.default.removeItem(at: fileURL)
                        print("Файл удален: \(fileURL)")
                    } catch {
                        print("Ошибка при удалении файла: \(error)")
                    }
                }
    
                viewContext.delete(coin)
                try viewContext.save()
                print("Монета с ID \(id) удалена")
            } else {
                print("Монета с ID \(id) не найдена")
            }
        } catch {
            print("Ошибка при удалении монеты: \(error)")
        }
    }
    
    func deleteEntry(at offsets: IndexSet) {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        do {
            let items = try viewContext.fetch(fetchRequest)
            for index in offsets {
                let item = items[index]
                viewContext.delete(item)
            }
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Неизвестная ошибка \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteAllCoins() {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        do {
            let items = try container.viewContext.fetch(fetchRequest)
            for item in items {
                container.viewContext.delete(item)
            }
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Неизвестная ошибка \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getAllCoins() -> [CoinEntity] {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        
        do {
            let coins = try viewContext.fetch(fetchRequest)
            return coins
        } catch {
            print("Ошибка при получении монет: \(error)")
            return []
        }
    }

}

