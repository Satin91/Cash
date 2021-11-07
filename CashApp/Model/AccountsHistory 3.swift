//
//  AccountsHistory.swift
//  CashApp
//
//  Created by Артур on 14.01.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import RealmSwift


class AccountsHistory: Object {
    @objc dynamic var name = "My transaction"
    @objc dynamic var accountName = ""
    @objc dynamic var secondAccountName = ""
    @objc dynamic var accountID = ""
    @objc dynamic var secondAccountID = ""
    @objc dynamic var categoryID = ""
    @objc dynamic var scheduleID = ""
    @objc dynamic var payPerTimeID = ""
    @objc dynamic var payDate = Date()
    @objc dynamic var sum: Double = 0
    @objc dynamic var convertedSum: Double = 0
    @objc dynamic var date: Date!
    @objc dynamic var currencyISO = "USD"
    @objc dynamic var image: String?
    @objc dynamic var historyID = NSUUID.init().uuidString
    override static func primaryKey() -> String? {
        return "historyID"
    }
    convenience init (name: String,
                      accountName: String,
                      secondAccountName: String,
                      accountID: String,
                      secondAccountID: String,
                      categoryID: String,
                      scheduleID: String,
                      payPerTimeID: String,
                      sum: Double,
                      convertedSum: Double,
                      date: Date,
                      currencyISO: String,
                      image:String?) {
        self.init()
        self.name = name
        self.accountName = accountName
        self.secondAccountName = secondAccountName
        self.accountID = accountID
        self.secondAccountID = secondAccountID
        self.categoryID  = categoryID
        self.scheduleID = scheduleID
        self.payPerTimeID = payPerTimeID
        self.sum = sum
        self.convertedSum = convertedSum
        self.date = date
        self.image = image
        self.currencyISO = currencyISO
    }
}
