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
///case cash = 2
///case box = 3

///case approach = 1
///case regular = 2
///case debt = 3
///case history = 4
///case borrow = 5
///case operationSpending = 9 /// OperationViewController
///case operationIncome = 10 /// OperationViewController



let cardObjects =              fetchAccounts(accountType: 1).sorted(byKeyPath: "date", ascending: false)//Card = 1
let cashObjects =              fetchAccounts(accountType: 2).sorted(byKeyPath: "date", ascending: false)//Cash = 2
let boxObjects =               fetchAccounts(accountType: 3).sorted(byKeyPath: "date", ascending: false)//Box = 3

let approachObjects =          fetchEntity(accountType: 1).sorted(byKeyPath: "date", ascending: false)//OperIncome
let regularObjects =           fetchEntity(accountType: 2).sorted(byKeyPath: "date", ascending: false)//Regular = 2
let debtObjects =              fetchEntity(accountType: 3).sorted(byKeyPath: "date", ascending: false)//Debt = 3

//let historyObjects =           outstanding(accountType: 8).sorted(byKeyPath: "date", ascending: false)//History = 8
let expenceObjects =             fetchEntity(accountType: 4).sorted(byKeyPath: "date", ascending: false)//OperExpence

let historyObjects =              realm.objects(AccountsHistory.self).sorted(byKeyPath: "date", ascending: false)

///Меню в OperationViewController сегмент 1
///Operation Payment
var operationExpence = [expenceObjects]
///Operation Scheduler
//var operationProfit = [operationIncomeObjects,incomeObjects]
var operationScheduler = [approachObjects,regularObjects,debtObjects]
///Меню в AccountsViewController
var accountsObjects = [cardObjects,boxObjects,cashObjects]


func fetchAccounts(accountType: Int) ->Results<MonetaryAccount>{
    let IntToString: String = String(accountType)
    let object = realm.objects(MonetaryAccount.self).filter("accountType = \(IntToString)")
    return object
}

func fetchEntity(accountType: Int) ->Results<MonetaryEntity> {
    let IntToString: String = String(accountType)
    let object = realm.objects(MonetaryEntity.self).filter("accountType = \(IntToString)")
    return object
}

func addObject(text: String, image: UIImage?,sum: Double?,secondSum: Double?, type: MonetaryType){
    
    var summ: Double = 0
    var secondSumm: Double = 0
    if sum != nil {
        summ = sum!
    }
    if secondSum != nil {
        secondSumm = secondSum!
    }
    let object2 = MonetaryEntity(name: text, sum: summ, secondSum: secondSumm, date: Date(), image: image?.pngData(), accountType: type)
    
    DBManager.addEntityObject(object: [object2])
}

func appendAccountsArray(object: [Results<MonetaryAccount>]) -> [MonetaryAccount]{
    var monetaryArray: [MonetaryAccount] = []
    for (_, index) in object.enumerated() {
        monetaryArray.append(contentsOf: index)
    }
     return monetaryArray
    }






//var accountObjectsToSave = [MonetaryAccount(name: "MyCard", balance: 2547, targetSum: 0, date: nil, imageForAccount: imageToData(imageName: "card"), imageForCell: imageToData(imageName: "card"), accountType: .card, isMainAccount: true),MonetaryAccount(name: "Savings on new phone!", balance: 25, targetSum: 3750, date: nil, imageForAccount: imageToData(imageName: "cash"), imageForCell: imageToData(imageName: "cash"), accountType: .box, isMainAccount: false)]

