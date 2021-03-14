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
    @objc dynamic var name = "Some history"
    @objc dynamic var entityIdentifier = ""
    @objc dynamic var accountIdentifier = ""
    @objc dynamic var sum: Double = 0
    @objc dynamic var date: Date?
    @objc dynamic var image: Data?
    convenience init (name: String, accountIdentifier: String,entityIdentifier: String, sum: Double, date: Date?, image:Data?) {
        self.init()
        self.name = name
        self.accountIdentifier = accountIdentifier
        self.entityIdentifier  = entityIdentifier
        self.sum = sum
        self.date = date
        self.image = image
    }
}
