//
//  AccountModel.swift
//  CashApp
//
//  Created by Артур on 29.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import RealmSwift

//MARK: Monetary Account
class MonetaryAccount: Object, Comparable {
    static func < (lhs: MonetaryAccount, rhs: MonetaryAccount) -> Bool {
        return lhs.name > rhs.name
    }
    @objc dynamic var name: String = "My account"
    @objc dynamic var balance: Double = 0
    @objc dynamic var targetSum: Double = 0 // не используется в данной версии
    @objc dynamic var date: Date?
    @objc dynamic var imageForCell = "card"
    @objc dynamic var imageForAccount = "account1"
    @objc dynamic var currencyISO = "USD"
    @objc dynamic var isMainAccount = false
    @objc dynamic var isUseForTudayBalance = true
    @objc dynamic var isBlock = false
    @objc dynamic var accountType: Int = AccountType.ordinary.rawValue
    @objc dynamic var accountID = NSUUID.init().uuidString
    var stringAccountType: AccountType {
        get { return AccountType(rawValue: accountType)! }
        set { accountType = newValue.rawValue }
        }
    override static func primaryKey() -> String? {
        return "accountID"
    }
    convenience init(name: String,balance:Double,targetSum: Double,date:Date?,imageForAccount:String,imageForCell: String,accountType:AccountType?,currencyISO: String,isMainAccount: Bool,isUseForTudayBalance: Bool,isBlock: Bool) {
        self.init()
        self.name = name
        self.imageForCell = imageForCell
        self.imageForAccount = imageForAccount
        self.balance = balance
        self.targetSum = targetSum
        self.date = date
        self.isMainAccount = isMainAccount
        self.currencyISO = currencyISO
        self.isUseForTudayBalance = isUseForTudayBalance
        self.isBlock = isBlock
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
