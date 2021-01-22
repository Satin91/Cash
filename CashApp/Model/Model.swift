//
//  File.swift
//  CashApp
//
//  Created by Артур on 7/29/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import RealmSwift

//MARK: Monetary Entity
class MonetaryEntity: Object {
    @objc dynamic var name: String = "Some Name"
    @objc dynamic var sum: Double = 0
    @objc dynamic var secondSum: Double = 0
    @objc dynamic var date: Date?
    @objc dynamic var image: Data?
    @objc dynamic var accountType: Int = MonetaryType.approach.rawValue
    @objc dynamic var monetaryID = NSUUID.init().uuidString
    var stringEntityType: MonetaryType {
        get { return MonetaryType(rawValue: accountType)! }
        set { accountType = newValue.rawValue }
        }
    override static func primaryKey() -> String? {
        return "monetaryID"
    }
    convenience init(name: String,sum:Double, secondSum: Double,date:Date?,image:Data?,accountType:MonetaryType?) {
        self.init()
        self.name = name
        self.sum = sum
        self.secondSum = secondSum
        self.image = image
        self.date = date
        if let typeAC = accountType?.rawValue{
        self.accountType = typeAC
        }else {print("Вернулся nil")}
    }
    func initType() -> String {
        var text = ""
        switch accountType{
        case 1 : text = "Approach"
        case 2 : text = "Regular"
        case 3 : text = "Debt"
        case 4 : text = "Expence"
        default:break
        }
        return text
    }
}

//MARK: Monetary Account

class MonetaryAccount: Object {
    @objc dynamic var name: String = "Some Name"
    @objc dynamic var balance: Double = 0
    @objc dynamic var targetSum: Double = 0
    @objc dynamic var date: Date?
    @objc dynamic var imageForCell: Data?
    @objc dynamic var imageForAccount: Data?
    @objc dynamic var isMainAccount = false
    @objc dynamic var accountType: Int = AccountType.card.rawValue
    @objc dynamic var accountID = NSUUID.init().uuidString
    var stringAccountType: AccountType {
        get { return AccountType(rawValue: accountType)! }
        set { accountType = newValue.rawValue }
        }
    override static func primaryKey() -> String? {
        return "accountID"
    }
    convenience init(name: String,balance:Double,targetSum: Double,date:Date?,imageForAccount:Data?,imageForCell: Data?,accountType:AccountType?,isMainAccount: Bool) {
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
        case 1 : text = "Card"
        case 2 : text = "Cash"
        case 3 : text = "Box"
        
        default:break
        }
        return text
    }
}

extension MonetaryEntity {
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
enum AccountType: Int {
    case card = 1
    case cash = 2
    case box =  3
}
enum MonetaryType: Int {
    case approach = 1
    case regular = 2
    case debt = 3
    case expence = 4
}





