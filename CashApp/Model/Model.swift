//
//  File.swift
//  CashApp
//
//  Created by Артур on 7/29/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import RealmSwift

class MonetaryEntity: Object {
    @objc dynamic var name: String = "Some Name"
    @objc dynamic var sum: Double = 0
    @objc dynamic var userDescription: String?
    @objc dynamic var date: Date?
    @objc dynamic var image: Data?
    @objc dynamic var userPersent: Double = 0
    @objc dynamic var accountType: Int = MonetaryType.approach.rawValue
    @objc dynamic var monetaryID = NSUUID.init().uuidString
    var stringAccountType: MonetaryType {
        get { return MonetaryType(rawValue: accountType)! }
        set { accountType = newValue.rawValue }
        }
    
    override static func primaryKey() -> String? {
        return "monetaryID"
    }
    convenience init(name: String,sum:Double,userDescription:String?,date:Date?,image:Data?,accountType:MonetaryType?, userPerent: Double) {
        self.init()
        self.name = name
        self.image = image
        self.sum = sum
        self.userDescription = userDescription
        self.date = date
        self.userPersent = userPerent
        if let typeAC = accountType?.rawValue{
        self.accountType = typeAC
        }else {print("Вернулся nil")}
    }
    func initType() -> String {
        var text = ""
        switch accountType{
        case 1 : text = "Card"
        case 2 : text = "Box"
        case 3 : text = "Cash"
        case 4 : text = "Debt"
        case 5 : text = "Bor"
        case 6 : text = "Regular"
        case 7 : text = "Income"

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
enum MonetaryType: Int {
    case card = 1
    case box = 2
    case cash = 3
    case debt = 4
    case borrow = 5
    case regular = 6
    case approach = 7
    case history = 8
    case operationExpence = 9
    case operationIncome = 10
}





