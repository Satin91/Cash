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
    @objc dynamic var accountID = ""
    @objc dynamic var monetaryID = ""
    @objc dynamic var scheduleID = ""
    @objc dynamic var sum: Double = 0
    @objc dynamic var date: Date!
    @objc dynamic var image: String?
    convenience init (name: String, accountID: String, monetaryID: String, sum: Double, date: Date, image:String?) {
        self.init()
        self.name = name
        self.accountID = accountID
        self.monetaryID  = monetaryID
        self.sum = sum
        self.date = date
        self.image = image
    }
}
