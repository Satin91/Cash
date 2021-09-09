//
//  PayPerTimeModel.swift
//  CashApp
//
//  Created by Артур on 8.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//


import RealmSwift
import UIKit

class PayPerTime: Object {
    @objc dynamic var scheduleName = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var dateOfCreation = Date()
    @objc dynamic var target: Double = 0.0
    @objc dynamic var scheduleID = ""
    @objc dynamic var currencyISO = "USD"
    @objc dynamic var vector = false
    @objc dynamic var payPerTimeID = NSUUID.init().uuidString
    override static func primaryKey() -> String? {
        return "payPerTimeID"
    }
    convenience init(scheduleName: String,date: Date,dateOfCreation: Date, target: Double,currencyISO: String ,scheduleID: String, vector: Bool) {
        self.init()
        self.scheduleName = scheduleName
        self.date = date
        self.dateOfCreation = dateOfCreation
        self.target = target
        self.currencyISO = currencyISO
        self.scheduleID = scheduleID
        self.vector = vector
}
    
}
