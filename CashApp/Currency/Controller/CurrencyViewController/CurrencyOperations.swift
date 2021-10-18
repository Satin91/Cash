//
//  CurrencyOperations.swift
//  CashApp
//
//  Created by Артур on 28.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import RealmSwift
class CurrencyOperations {
    let manager = SubscriptionManager()
    // Delete currencies if PRO is no active
    
    
   func removeCurrencies() {
        
       for i in userCurrencyObjects {
           if i.ISO == mainCurrency?.ISO {
               try! realm.write({
                   i.ISOPriority = 0
                   realm.add(i,update: .all)
               })
           }
       }
       for (index,value) in userCurrencyObjects.enumerated() {
           try! realm.write({
               value.ISOPriority = index
               realm.add(value,update: .all)
           })
       }
       for (index,currency) in userCurrencyObjects.enumerated() {
            if currency.ISOPriority >= manager.allowedNumberOfCells(objectsCountFor: .currencies) {
                try! realm.write({
                    currency.ISOPriority = 15888
                })
            }
        }
      
    }
    // Вызывается для проверки подписки
    func checkPRO() {
        if  userCurrencyObjects.count >= manager.allowedNumberOfCells(objectsCountFor: .currencies) {
         removeCurrencies()
        }
    }
    // Delete row after cell swipe
    func updateDataAfterRemove(indexPath: IndexPath) {
        for (index,value) in userCurrencyObjects.enumerated() {
            if index == indexPath.row {
                userCurrencyObjects.remove(at: indexPath.row)
                try! realm.write {
                    value.ISOPriority = 15888
                    realm.add(value,update: .all)
            }
                continue
        }
            for (index,value) in userCurrencyObjects.enumerated() {
                try! realm.write {
                value.ISOPriority = index
                    realm.add(value,update: .all)
                }
            }
        }
    }
}
