//
//  File.swift
//  CashApp
//
//  Created by Артур on 7/29/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import RealmSwift

//MARK: Monetary Entity
class MonetaryCategory: Object {
    @objc dynamic var name: String = "My category"
    @objc dynamic var sum: Double = 0
    @objc dynamic var limit: Double = 0
    @objc dynamic var limitBalance: Double = 0
    @objc dynamic var isEnabledLimit = false
    @objc dynamic var image = "card"
    @objc dynamic var accountType: Int = CategoryType.expence.rawValue
    @objc dynamic var categoryID = NSUUID.init().uuidString
    var stringEntityType: CategoryType {
        get { return CategoryType(rawValue: accountType)! }
        set { accountType = newValue.rawValue }
        }
    override static func primaryKey() -> String? {
        return "categoryID"
    }
    convenience init(name: String,sum:Double, limit: Double,limitBalance: Double,image:String,categoryType:CategoryType?) {
        self.init()
        self.name = name
        self.sum = sum
        self.limit = limit
        self.limitBalance = limitBalance
        self.isEnabledLimit = isEnabledLimit
        self.image = image
        if let typeAC = categoryType?.rawValue{
        self.accountType = typeAC
        }else {print("Вернулся nil")}
    }
    func initType() -> String {
        var text = ""
        switch accountType{
        case 1 : text = "Expence"
        case 2 : text = "Income"
        default:break
        }
        return text
    }
}

//MARK: Monetary Account

class MonetaryAccount: Object {
    @objc dynamic var name: String = "My account"
    @objc dynamic var balance: Double = 0
    @objc dynamic var targetSum: Double = 0 // не используется в данной версии
    @objc dynamic var date: Date?
    @objc dynamic var imageForCell = "card"
    @objc dynamic var imageForAccount = "account1"
    @objc dynamic var isMainAccount = false
    @objc dynamic var accountType: Int = AccountType.ordinary.rawValue
    @objc dynamic var accountID = NSUUID.init().uuidString
    var stringAccountType: AccountType {
        get { return AccountType(rawValue: accountType)! }
        set { accountType = newValue.rawValue }
        }
    override static func primaryKey() -> String? {
        return "accountID"
    }
    convenience init(name: String,balance:Double,targetSum: Double,date:Date?,imageForAccount:String,imageForCell: String,accountType:AccountType?,isMainAccount: Bool) {
        self.init()
        self.name = name
        self.imageForCell = imageForCell
        self.imageForAccount = imageForAccount
        self.balance = balance
        self.targetSum = targetSum
        self.date = date
        self.isMainAccount = isMainAccount
        if let typeAC = accountType?.rawValue{
        self.accountType = typeAC
        }else {print("Вернулся nil, Model viw controller")}
    }
    func initType() -> String {
        var text = ""
        switch accountType{
        case 1 : text = "Ordinary"
        case 2 : text = "Savings"

        
        default:break
        }
        return text
    }
}

//MARK: Monetary scheduler
class MonetaryScheduler: Object {
    @objc dynamic var name: String = "My schedule"
    @objc dynamic var target: Double = 0
    @objc dynamic var available: Double = 0
    @objc dynamic var sumPerTime: Double = 0
    @objc dynamic var date: Date?
    @objc dynamic var dateRhythm: Int = DateRhythm.none.rawValue
    @objc dynamic var image: String = "card"
    @objc dynamic var isUseForTudayBalance = true
    @objc dynamic var scheduleType: Int = ScheduleType.oneTime.rawValue
    @objc dynamic var scheduleID = NSUUID.init().uuidString
    var stringScheduleType: ScheduleType {
        get { return ScheduleType(rawValue: scheduleType)! }
        set { scheduleType = newValue.rawValue }
        }
    var stringDateRhythm: DateRhythm {
        get { return DateRhythm(rawValue: dateRhythm)!}
        set { dateRhythm = newValue.rawValue}
    }
    override static func primaryKey() -> String? {
        return "scheduleID"
    }
    convenience init(name: String,sum: Double,balance:Double,sumPerTime:Double,date:Date?,dateRhytm:Int?,image: String,isUseForTudayBalance: Bool,scheduleType:ScheduleType,dateRhythm: DateRhythm) {
        self.init()
        self.name = name
        self.image = image
        self.target = sum
        self.available = balance
        self.sumPerTime = sumPerTime
        self.date = date
        self.isUseForTudayBalance = isUseForTudayBalance
        self.scheduleType = scheduleType.rawValue
        self.dateRhythm = dateRhythm.rawValue
    }
}


struct historyStructModel {  // Создал структуру для сортировки объектов т.к. ПОЧЕМУ ТО нельзя сортировать realm массивы
    var name = ""
    var sum = Double()
    var date = Date()
}

extension MonetaryCategory {
    func updateObjext() {
        try! realm!.write{
            realm?.add(self, update: .all)
        }
}
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
enum ScheduleType: Int {
    case oneTime = 1
    case regular = 2
}

enum DateRhythm: Int {
    case none = 0
    case week = 1
    case month = 2
}


class PayPerTime: Object {
    @objc dynamic var scheduleName = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var available: Double = 0.0
    @objc dynamic var sumPerTime: Double = 0.0
    @objc dynamic var scheduleID = ""
    @objc dynamic var payPerTimeID = NSUUID.init().uuidString
    override static func primaryKey() -> String? {
        return "payPerTimeID"
    }
    convenience init(scheduleName: String,date: Date, available: Double,sumPerTime: Double,scheduleID: String) {
        self.init()
        self.scheduleName = scheduleName
        self.date = date
        self.available = available
        self.sumPerTime = sumPerTime
        self.scheduleID = scheduleID
}
}


