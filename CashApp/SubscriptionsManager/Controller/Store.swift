//
//  Store.swift
//  CashApp
//
//  Created by Артур on 6.11.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import StoreKit

class Store {
    @Published var products: [Product] = []
    
    enum Identifiers: String, CaseIterable {
        case monthly = "cashApp.month.subscription"
        case annual  = "by.cashApp.annual.subscription"
    }
    
    func fetchProducts() {
        Task.init(priority: .high) {
            do {
                let products = try await Product.products(for: [Identifiers.monthly.rawValue,Identifiers.annual.rawValue])
                DispatchQueue.main.async {
                    self.products = products
                    }
                if products.isEmpty == false {
                        await isPurchased(products: products)
                    NotificationCenter.default.post(name: NSNotification.Name("ReceiveSubscriptionsProducts"), object: ["Success":0])
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name("ReceiveSubscriptionsProducts"), object: ["Error":1])
                }
            } catch {
                NotificationCenter.default.post(name: NSNotification.Name("ReceiveSubscriptionsProducts"), object: ["Error":1])
                print(error)
            }
        }
    }
    // Проверка на действие подписки
    func isPurchased(products: [Product]) async {
        NetworkMonitor.shared.startMonitoring()
        guard NetworkMonitor.shared.isConnected == true else {
            NetworkMonitor.shared.stopMonitoring()
            return
        }
        
        for product in products {
            let state = await product.currentEntitlement
            print("Запуск проверки")
                switch state {
                case .verified(let transaction):
                    // Здесь происходит получение покупки
                    SubscribtionStatus.isAvailable = true
                    print(transaction.productID)
                    return
                case .unverified(_):
                    SubscribtionStatus.isAvailable = false
                case .none:
                    SubscribtionStatus.isAvailable = false
                }
        }
        NetworkMonitor.shared.stopMonitoring()
     
        }
    

func purchase(product: Product) {
    Task {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    SubscribtionStatus.isAvailable = true
                    SubscribtionStatus.trialWasActive = true
                    // Здесь происходит получение покупки
                    print(transaction.productID)
                case .unverified(_):
                    break
                }
            case .pending:
                break
            case .userCancelled:
                break
            }
        } catch {
            
        }
    }
}
}

