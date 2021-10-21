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
        
       try! realm.write({ // Начало блока записи
       for i in userCurrencyObjects {
           if i.ISO == mainCurrency?.ISO {
               
                   i.ISOPriority = 0
                   realm.add(i,update: .all)
           } else if i.ISOPriority == 0 && i.ISO != mainCurrency?.ISO {
               i.ISOPriority += 1
           }
       }
       
       for (index,value) in userCurrencyObjects.enumerated() {
               value.ISOPriority = index
               realm.add(value,update: .all)
           
       }
       for (index,currency) in userCurrencyObjects.enumerated() {
            if currency.ISOPriority >= manager.allowedNumberOfCells(objectsCountFor: .currencies) {
                
                    currency.ISOPriority = 15888
            }
        }
           
        }) // Конец блока записи
      
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
