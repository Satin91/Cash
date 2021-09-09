//
//  SchedulerModel.swift
//  CashApp
//
//  Created by Артур on 8.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import RealmSwift


//MARK: Monetary scheduler
class MonetaryScheduler: Object, Comparable {
    static func < (lhs: MonetaryScheduler, rhs: MonetaryScheduler) -> Bool {
        return lhs.name > rhs.name
    }
    @objc dynamic var name: String = "My schedule"
    @objc dynamic var target: Double = 0
    @objc dynamic var available: Double = 0
    @objc dynamic var sumPerTime: Double = 0
    @objc dynamic var date = Date()
    @objc dynamic var dateOfCreation = Date()
    @objc dynamic var dateRhythm: Int = DateRhythm.none.rawValue
    @objc dynamic var image: String = "card"
    @objc dynamic var currencyISO = "USD"
    @objc dynamic var isUseForTudayBalance = true
    @objc dynamic var vector = false
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
    convenience init(name: String,target: Double,available:Double,sumPerTime:Double,date:Date,dateOfCreation: Date,dateRhytm:Int?,image: String,currencyISO: String,isUseForTudayBalance: Bool,scheduleType:ScheduleType,dateRhythm: DateRhythm, vector: Bool) {
        self.init()
        self.name = name
        self.target = target
        self.available = available
        self.sumPerTime = sumPerTime
        self.date = date
        self.dateOfCreation = dateOfCreation
        self.dateRhythm = dateRhythm.rawValue
        self.image = image
        self.vector = vector
        self.currencyISO = currencyISO
        self.isUseForTudayBalance = isUseForTudayBalance
        self.scheduleType = scheduleType.rawValue
        
    }
}



enum ScheduleType: Int {
    case oneTime = 1
    case multiply = 2
    case regular = 3
    case goal = 4
}


