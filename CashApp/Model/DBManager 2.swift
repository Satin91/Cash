//
//  DBManager.swift
//  CashApp
//
//  Created by Артур on 10/21/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import RealmSwift


var realm = try! Realm(configuration: .init( deleteRealmIfMigrationNeeded: true))
var results: Results<MonetaryEntity>!


class DBManager {
    
    static func updateAccount(accountType: [MonetaryAccount], indexPath: Int, addSum: Double) {
        let count = EnumeratedAccounts(array: accountsObjects).count - 1 // Когда отсутствуют счета count = 0
        guard indexPath <= count else {return}
                try! realm.write {
                accountType[indexPath].balance -= addSum
                realm.add(accountType, update: .all)
            }
    }
    
    static func updateObject(objectType: [MonetaryEntity], indexPath: Int, addSum: Double) {
        try! realm.write {
            objectType[indexPath].sum += addSum
            realm.add(objectType, update: .all)
    }
}
    
    static func updateEntity(accountType: [MonetaryEntity], indexPath: Int, addSum: Double) {
        let count = EnumeratedAccounts(array: accountsObjects).count // Когда отсутствуют счета count = 0
        try! realm.write {
                if count > 0, indexPath > 0 {
                accountType[indexPath].sum -= addSum
            }
                realm.add(accountType, update: .all)
        }
    }

    static func removeObject(Object: MonetaryEntity){
        try! realm.write{
            realm.delete(Object)
        }
    }
    
    
    static func removeHistoryObject(object: AccountsHistory) {
        try! realm.write{
            realm.delete(object)
        }
    }
    
    static func addHistoryObject(object: AccountsHistory) {
        try! realm.write {
            realm.add(object)
        }
    }
    ///Функиця для быстрой записи в БазуДанных
    static func addEntityObject(object: [MonetaryEntity]) {
        try! realm.write {
            realm.add(object)
        }
    }
    static func addAccountObject(object: [MonetaryAccount]) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func obtainAnyObjects(type: String)-> [MonetaryEntity] {
        results = realm.objects(MonetaryEntity.self).filter("accountType = \(type)")
       // let models = realm.objects(MonetaryEntity.self).filter("accountType = \(type)")
        return Array(results)
    }
    

  
    static func clearAll () {
       try! realm.write{
           realm.deleteAll()
       }       
   }
}

 
