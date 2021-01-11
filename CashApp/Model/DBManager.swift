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
    
    static func updateAccount(accountType: [MonetaryEntity], indexPath: Int, addSum: Double) {
        
        try! realm.write {

            accountType[indexPath].sum -= addSum
            realm.add(accountType, update: .all)
    }
    }
    
    static func updateObject(objectType: [MonetaryEntity], indexPath: Int, addSum: Double) {
    
        try! realm.write {

            objectType[indexPath].sum += addSum
            realm.add(objectType, update: .all)
    }
}
    static func removeObject(Object: MonetaryEntity){
        try! realm.write{
            realm.delete(Object)
        }
    }
    
    ///Функиця для быстрой записи в БазуДанных
    static func addObject(object: [MonetaryEntity]) {
       
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

 
