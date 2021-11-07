//
//  SaveCategory.swift
//  CashApp
//
//  Created by Артур on 11.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import RealmSwift

class SaveCategory {
    
    func saveHistoryForCategory(selectedAccountObject: MonetaryAccount, historyObject: AccountsHistory, enteredSum: Double) {
        guard selectedAccountObject.accountID != "NO ACCOUNT" else{
            DBManager.addHistoryObject(object: historyObject)
            return}
        historyObject.accountID = selectedAccountObject.accountID
        try! realm.write({
            selectedAccountObject.balance += historyObject.sum
            realm.add(selectedAccountObject, update: .all)
        })
        DBManager.addHistoryObject(object: historyObject)

        }
}
