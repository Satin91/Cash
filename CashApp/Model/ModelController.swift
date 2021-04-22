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
//let savingsObjects =              fetchAccounts(accountType: 2).sorted(byKeyPath: "date", ascending: false)//Cash = 2

 
let oneTimeObjects =           fetchSchedulers(scheduleType: 1).sorted(byKeyPath: "date", ascending: false)//OneTime = 1
let regularObjects =           fetchSchedulers(scheduleType: 2).sorted(byKeyPath: "date", ascending: false)//Regular = 2

//let approachObjects =          fetchEntity(accountType: 1).sorted(byKeyPath: "date", ascending: false)//OperIncome
//let regularObjects =           fetchEntity(accountType: 2).sorted(byKeyPath: "date", ascending: false)//Regular = 2
//let debtObjects =              fetchEntity(accountType: 3).sorted(byKeyPath: "date", ascending: false)//Debt = 3

//let historyObjects =           outstanding(accountType: 8).sorted(byKeyPath: "date", ascending: false)//History = 8
let expenceObjects =           fetchCategories(accountType: 1).sorted(byKeyPath: "name", ascending: false)//OperExpence
let incomeObjects =            fetchCategories(accountType: 2).sorted(byKeyPath: "name", ascending: false)//OperIncome
let historyObjects =            realm.objects(AccountsHistory.self).sorted(byKeyPath: "date", ascending: false)

///Меню в OperationViewController сегмент 1
///Operation Payment
var categoryGroup = [expenceObjects,incomeObjects]
///Operation Scheduler

var schedulerGroup = [oneTimeObjects,regularObjects]
///Меню в AccountsViewController
var accountsGroup = [cardObjects]


func fetchAccounts(accountType: Int) ->Results<MonetaryAccount>{
    let IntToString: String = String(accountType)
    let object = realm.objects(MonetaryAccount.self).filter("accountType = \(IntToString)")
    return object
}

func fetchCategories(accountType: Int) ->Results<MonetaryCategory> {
    let IntToString: String = String(accountType)
    let object = realm.objects(MonetaryCategory.self).filter("accountType = \(IntToString)")
    return object
}

func fetchSchedulers(scheduleType: Int) ->Results<MonetaryScheduler> {
    let intToString: String = String(scheduleType)
    let object = realm.objects(MonetaryScheduler.self).filter("scheduleType= \(intToString)")
    return object
}


//func addObject(text: String, image: String?,sum: Double?,secondSum: Double?, type: CategoryType){
//    
//    var summ: Double = 0
//    var limit: Double = 0
//    if sum != nil {
//        summ = sum!
//    }
//    if secondSum != nil {
//        limit = secondSum!
//    }
//    let object2 = MonetaryCategory(
//   // let object2 = MonetaryCategory(name: text, sum: summ, secondSum: limit, date: Date(), image: image, accountType: type)
//    
//    DBManager.addEntityObject(object: [object2])
//}








//var accountObjectsToSave = [MonetaryAccount(name: "MyCard", balance: 2547, targetSum: 0, date: nil, imageForAccount: "account1", imageForCell: "card", accountType: .ordinary, isMainAccount: true),MonetaryAccount(name: "Savings on new phone!", balance: 25, targetSum: 3750, date: nil, imageForAccount: "cash", imageForCell: "cash", accountType: .savings, isMainAccount: false)]
//var schedulerObjectsToSave = [MonetaryScheduler(name: "Schedyle", sum: 1450, balance: 0, sumPerTime: 0, date: Date(), dateRhytm: nil, image: "savings", isUseForTudayBalance: true, scheduleType: .oneTime)]
//var categoryObjectToSave = [MonetaryCategory(name: "Expence", sum: 15, limit: 0, limitBalance: 0, image: "card", categoryType: .expence),MonetaryCategory(name: "Income", sum: 15, limit: 0, limitBalance: 0, image: "savings", categoryType: .income)]

