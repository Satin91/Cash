//
//  RealmCurrency.swift
//  CashApp
//
//  Created by Артур on 3.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import RealmSwift

class CurrencyObject: Object, Comparable{
    static func < (lhs: CurrencyObject, rhs: CurrencyObject) -> Bool {
        return lhs.ISO > rhs.ISO
    }
    @objc dynamic var ISO: String = ""
    @objc dynamic var exchangeRate: Double = 0
    @objc dynamic var ISOID = NSUUID.init().uuidString
    @objc dynamic var ISOPriority: Int = 15888
    
    override static func primaryKey() -> String? {
        return "ISOID"
    }
    convenience init(ISO: String,exchangeRate: Double) {
    self.init()
        
        self.ISO = ISO
        self.exchangeRate = exchangeRate
    }
}

class MainCurrency: Object, Comparable {
    static func < (lhs: MainCurrency, rhs: MainCurrency) -> Bool {
        lhs.ISO < lhs.ISO
    }
    @objc dynamic var ISO: String = "USD"
    @objc dynamic var ISOID = NSUUID.init().uuidString
    override static func primaryKey() -> String? {
        return "ISOID"
    }
    convenience init(ISO: String) {
    self.init()
        self.ISO = ISO
    }
}
