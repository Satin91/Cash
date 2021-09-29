//
//  File.swift
//  CashApp
//
//  Created by Артур on 7/29/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import RealmSwift



//MARK: CurrencyObject

//MARK: Monetary Category
class MonetaryCategory: Object, Comparable{
    
    static func < (lhs: MonetaryCategory, rhs: MonetaryCategory) -> Bool {
        return lhs.name > rhs.name
    }
    
    @objc dynamic var name: String = "My category"
    @objc dynamic var sum: Double = 0
    @objc dynamic var limit: Double = 0
    @objc dynamic var limitBalance: Double = 0
    @objc dynamic var isEnabledLimit = false
    @objc dynamic var image = "card"
    @objc dynamic var currencyISO = "USD"
    @objc dynamic var categoryType: Int = CategoryType.expence.rawValue
    @objc dynamic var categoryID = NSUUID.init().uuidString
    @objc dynamic var position : Int = 0
    var stringEntityType: CategoryType {
        get { return CategoryType(rawValue: categoryType)! }
        set { categoryType = newValue.rawValue }
        }
    var vector : Bool {
        get { if CategoryType(rawValue: categoryType)! == .expence {
            return false
        }else {
            return true
        }}
    }
    override static func primaryKey() -> String? {
        return "categoryID"
    }
    convenience init(name: String,sum:Double, limit: Double,limitBalance: Double,image:String,currencyISO: String,categoryType:CategoryType,position: Int) {
        self.init()
        self.name = name
        self.sum = sum
        self.limit = limit
        self.limitBalance = limitBalance
        self.isEnabledLimit = isEnabledLimit
        self.image = image
        self.currencyISO = currencyISO
        self.categoryType = categoryType.rawValue
        self.position = position
      
    }
}



struct historyStructModel {  // Создал структуру для сортировки объектов т.к. ПОЧЕМУ ТО нельзя сортировать realm массивы
    var name = ""
    var sum = Double()
    var date = Date()
}

    enum vector:String {
        case to
        case out
    }


enum CategoryType: Int {
    case expence = 1
    case income = 2
}
enum AccountType: Int {
    case ordinary = 1
    case savings =  2 // не используется в доной версии
}

enum DateRhythm: Int {
    case none = 0
    case month = 1
    case week = 2
    case day = 3
  
}




class TodayBalance: Object {
    @objc dynamic var commonBalance: Double = 0
    @objc dynamic var currentBalance: Double = 0
    @objc dynamic var endDate = Date()
    @objc dynamic var todayBalanceID = NSUUID.init().uuidString
    override static func primaryKey() -> String? {
        return "todayBalanceID"
    }
    convenience init(commonBalance: Double, currentBalance: Double, endDate: Date) {
        self.init()
        self.commonBalance = commonBalance
        self.currentBalance = currentBalance
        self.endDate = endDate
    }
}


