//
//  ModelController.swift
//  CashApp
//
//  Created by Артур on 10/18/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import Foundation
import RealmSwift

///case card = 1
///case box = 2
///case cash = 3
///case debt = 4
///case borrow = 5
///case regular = 6
///case income = 7
///case history = 8
///case operationSpending = 9 /// OperationViewController
///case operationIncome = 10 /// OperationViewController



let cardObjects =              outstanding(accountType: 1).sorted(byKeyPath: "date", ascending: false)//Card = 1
let boxObjects =               outstanding(accountType: 2).sorted(byKeyPath: "date", ascending: false)//Box = 2
let cashObjects =              outstanding(accountType: 3).sorted(byKeyPath: "date", ascending: false)//Cash = 3
let debtObjects =              outstanding(accountType: 4).sorted(byKeyPath: "date", ascending: false)//Debt = 4
let borrowObjects =            outstanding(accountType: 5).sorted(byKeyPath: "date", ascending: false)//Borrow = 5
let regularObjects =           outstanding(accountType: 6).sorted(byKeyPath: "date", ascending: false)//Regular = 6
let incomeObjects =            outstanding(accountType: 7).sorted(byKeyPath: "date", ascending: false)//Income = 7
let historyObjects =           outstanding(accountType: 8).sorted(byKeyPath: "date", ascending: false)//History = 8
let operationSpendingObjects = outstanding(accountType: 9).sorted(byKeyPath: "date", ascending: false)//OperSpending
let operationIncomeObjects =   outstanding(accountType: 10).sorted(byKeyPath:"date", ascending: false)//OperIncome



///Меню в OperationViewController сегмент 1
///Operation Payment
var operationPayment = [operationSpendingObjects]
///Operation Scheduler
//var operationProfit = [operationIncomeObjects,incomeObjects]
var operationScheduler = [incomeObjects,regularObjects,debtObjects]
///Меню в AccountsViewController
var accountsObjects = [cardObjects,boxObjects,cashObjects]
///Словарик для истории
var historyDictionary = [String:String]()




func outstanding(accountType: Int)->Results<MonetaryEntity> {
    let IntToString: String = String(accountType)
    let object = realm.objects(MonetaryEntity.self).filter("accountType = \(IntToString)")
    return object
}

func addObject(text: String, image: UIImage?,sum: Double?, type: MonetaryType){
    var summ: Double = 0
    if sum != nil {
        summ = sum!
    }
    
    let object2 = MonetaryEntity(name: text, sum: summ, userDescription: nil, date: Date(), image: image?.pngData(), accountType:  type, userPerent: 0)
    
    DBManager.addObject(object: [object2])
}

func returnSumToObject(object: Results<MonetaryEntity>, secondObject: MonetaryEntity){
for i in EnumeratedSequence(array: [object]){
    if i.name == secondObject.name {
        try! realm.write {
            i.sum -= secondObject.sum
           
            realm.add(i, update: .all)
    }
       
    }
    
}
}




///History
//var historyObjects = [MonetaryEntity(name: "Shop", sum: 37, userDescription: nil, date: nil , image: imageToData(imageName: "other"), accountType: .history), MonetaryEntity(name: "Купил iPhone", sum: 978, userDescription: nil, date: Date(), image: imageToData(imageName: "clothes"), accountType: .history)]



//var box = [MonetaryEntity(name: "На вселик", sum: 0, userDescription: nil, date: Date(), image: imageToData(imageName: "card"), accountType: .box, userPerent: 37)]
///Income Objects
//var operationIncome = [MonetaryEntity(name: "Freelance", sum: 375, userDescription: "Отдают без задержек", date: someDateOfComponents, image: imageToData(imageName: "card"), accountType: .operationIncome),MonetaryEntity(name: "Freelance", sum: 375, userDescription: "Отдают без задержек", date: someDateOfComponents, image: imageToData(imageName: "card"), accountType: .operationIncome)]
//var operationExpence = [MonetaryEntity(name: "На продукты", sum: 0, userDescription: nil, date: nil, image: imageToData(imageName: "food"), accountType: .operationExpence), MonetaryEntity(name: "Вещи", sum: 35, userDescription: nil, date: nil, image: imageToData(imageName: "clothes"), accountType: .operationExpence)]
//
//var operationIncomeDept = [MonetaryEntity()]
//
/////Total Balance Accounts
//var card = [MonetaryEntity(name: "Cards", sum: 4562, userDescription: nil, date: nil, image: imageToData(imageName: "card"), accountType: .card),MonetaryEntity(name: "For iMac", sum: 1750, userDescription: nil, date: Date(), image: imageToData(imageName: "card") , accountType: .card) ]
//var box = [MonetaryEntity(name: "На велик", sum: 744, userDescription: nil, date: nil, image: imageToData(imageName: "card"), accountType: .box), MonetaryEntity(name: "На iPhone", sum: 1300, userDescription: nil, date: nil, image: nil, accountType: .box)]
//var cash = [MonetaryEntity(name: "Cash", sum: 233, userDescription: nil, date: Date(), image: imageToData(imageName: "cash"), accountType: .cash)]

//var mon = MonetaryEntity(name: "Cool!", sum: 87, userDescription: nil, date: nil, image: imageToData(imageName: "clothes"), accountType: .operationExpence)



//var realmObjectsToSave = [MonetaryEntity(name: "Cards", sum: 4562, userDescription: nil, date: nil, image: imageToData(imageName: "card"), accountType: .card, userPerent: 35),MonetaryEntity(name: "For iMac", sum: 1750, userDescription: nil, date: Date(), image: imageToData(imageName: "card") , accountType: .card, userPerent: 44),
//                          MonetaryEntity(name: "На велик", sum: 744, userDescription: nil, date: nil, image: imageToData(imageName: "card"), accountType: .box, userPerent: 35),
//                        MonetaryEntity(name: "На iPhone", sum: 1300, userDescription: nil, date: nil, image: nil, accountType: .box, userPerent: 35),
//                      MonetaryEntity(name: "Cash", sum: 233, userDescription: nil, date: Date(), image: imageToData(imageName: "cash"), accountType: .cash, userPerent: 35),
//                       MonetaryEntity(name: "На продукты", sum: 0, userDescription: nil, date: nil, image: imageToData(imageName: "food"), accountType: .operationExpence, userPerent: 35),
//                     MonetaryEntity(name: "Вещи", sum: 35, userDescription: nil, date: nil, image: imageToData(imageName: "clothes"), accountType: .operationExpence, userPerent: 35),
//                   MonetaryEntity(name: "Freelance", sum: 375, userDescription: "Отдают без задержек", date: someDateOfComponents, image: imageToData(imageName: "card"), accountType: .operationIncome, userPerent: 49),
//                 MonetaryEntity(name: "Freelance", sum: 375, userDescription: "Отдают без задержек", date: someDateOfComponents, image: imageToData(imageName: "card"), accountType: .operationIncome, userPerent: 24),
//               MonetaryEntity(name: "Income", sum: 255, userDescription: nil, date: nil, image: nil, accountType: .approach, userPerent: 24),
//             MonetaryEntity(name: "Regular", sum: 3750, userDescription: nil, date: nil, image: imageToData(imageName: "card"), accountType: .regular, userPerent: 4),
//           MonetaryEntity(name: "For new car", sum: 7894, userDescription: "Volvo S40", date:nil, image: imageToData(imageName: "card"), accountType: .debt, userPerent: 4)]



/////Total Balance Scheduler
//
//var income = [MonetaryEntity(name: "Income", sum: 255, userDescription: nil, date: nil, image: nil, accountType: .income)]
//var regular = [MonetaryEntity(name: "Regular", sum: 3750, userDescription: nil, date: nil, image: imageToData(imageName: "card"), accountType: .regular)]
//var debt = [MonetaryEntity(name: "For new car", sum: 7894, userDescription: "Volvo S40", date:nil, image: imageToData(imageName: "card"), accountType: .debt)]
//
//
//
//
//
//
//
//
//
////func saveRealm() {
////    for entity in [card,income,debt,cash] {
////        for entity2 in entity{
////        let newEntity = MonetaryEntity1()
////        newEntity.date = entity2.date
////        newEntity.image = entity2.image
////        newEntity.name = entity2.name
////        newEntity.accountType = entity2.accountType
////
////        DBManager.saveObject(realmData: newEntity)
////    }
////    }
////}
