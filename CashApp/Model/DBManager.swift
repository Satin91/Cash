//
//  DBManager.swift
//  CashApp
//
//  Created by Артур on 10/21/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import RealmSwift


var realm = try! Realm(configuration: .init( deleteRealmIfMigrationNeeded: true))
var results: Results<MonetaryCategory>!


class DBManager {
    
    static func updateAccount(accountType: [MonetaryAccount], indexPath: Int, addSum: Double) {
        let count = EnumeratedAccounts(array: accountsGroup).count - 1 // Когда отсутствуют счета count = 0
        guard indexPath <= count else {return}
                try! realm.write {
                accountType[indexPath].balance -= addSum
                realm.add(accountType, update: .all)
            }
    }
    
    static func updateCategory(objectType: [MonetaryCategory], indexPath: Int, addSum: Double) {
        try! realm.write {
            objectType[indexPath].sum += addSum
            realm.add(objectType, update: .all)
    }
}
    
    static func updateEntity(accountType: [MonetaryCategory], indexPath: Int, addSum: Double) {
        let count = EnumeratedAccounts(array: accountsGroup).count // Когда отсутствуют счета count = 0
        try! realm.write {
                if count > 0, indexPath > 0 {
                accountType[indexPath].sum -= addSum
            }
                realm.add(accountType, update: .all)
        }
    }

    static func removeCategoryObject(Object: MonetaryCategory){
        try! realm.write{
            realm.delete(Object)
        }
    }
    
    
    static func removeHistoryObject(object: AccountsHistory) {
        try! realm.write{
            realm.delete(object)
        }
    }
    
    static func addObject(object: Object) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func addHistoryObject(object: AccountsHistory) {
        try! realm.write {
            realm.add(object)
        }
    }
    ///Функиця для быстрой записи в БазуДанных
    static func addCategoryObject(object: MonetaryCategory) {
        try! realm.write {
            realm.add(object)
        }
    }
    static func addAccountObject(object: [MonetaryAccount]) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func obtainAnyObjects(type: String)-> [MonetaryCategory] {
        results = realm.objects(MonetaryCategory.self).filter("accountType = \(type)")
       // let models = realm.objects(MonetaryEntity.self).filter("accountType = \(type)")
        return Array(results)
    }
    
    static func fetchTB(date: Date) throws -> TodayBalance {
        guard let object = realm.objects(TodayBalance.self).first else {throw NSError(domain: "Returned nil", code: 1) }
        try! realm.write {
        object.endDate = date
            realm.add(object,update: .all)
        }
        return object
    }
  
    static func clearAll () {
       try! realm.write{
           realm.deleteAll()
       }       
   }
}

 
