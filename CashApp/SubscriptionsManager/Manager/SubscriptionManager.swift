//
//  SubscriptionManager.swift
//  CashApp
//
//  Created by Артур on 21.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import StoreKit
import Purchases


class SubscriptionManager: NSObject  {

    enum MonetaryObjectType: Int {
        case accounts
        case plans
        case categories
        case currencies
        var count: Int {
            switch self {
            case .accounts:
                return 2
            case .plans:
                return 1
            case .categories:
                return 4
            case .currencies:
                return 2
            }
        }
    }
    
    func allowedNumberOfCells(objectsCountFor: MonetaryObjectType) -> Int {
        // check value from userDefalts and set its to UserDefaults
        checkActiveEntitlement()
        
        let isActive = UserDefaults.standard.bool(forKey: "isAvailable")
        if isActive == true {
            return 1000
        } else {
            return objectsCountFor.count
        }
    }
    
    func checkActiveEntitlement(){
        // Проверка на валидность подписки
        Purchases.shared.purchaserInfo { [weak self]info, error in
            //guard let self = self else { return }
            guard let info = info, error == nil else { return }
            if info.entitlements.all["Standart"]?.isActive == true {
                Subscription.isAvailable = true
                print("subscription ifs true")
                
            } else {
                Subscription.isAvailable = false
                print("subscription is false")
                DispatchQueue.main.async {

                }
            }
        }
    }
    // Получение информации о типе подписки
    // packageIndex - индекс строки (в product)
    func fetchOfferingPackage(packageIndex: Int, completion: @escaping(Purchases.Package) -> Void ) {
        Purchases.shared.offerings { offerings, error in
            guard let offerings = offerings, error == nil else {return }
            guard let package = offerings.all.first?.value.availablePackages[packageIndex] else {
                
                return
            }
            
            completion(package)
    }
    }
    // Непосредственно сама покупка
    func purchase(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
            guard let transactions = transaction,
                  let info = info,
                  error == nil,
                  !userCancelled else {
                return
            }
            self.checkActiveEntitlement()
        }
    }
    
    
    func restorePurchases() {
        Purchases.shared.restoreTransactions { info, error in
            guard let info = info, error == nil else { return }
        }
    }
}
