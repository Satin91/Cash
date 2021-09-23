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

let currencyList = CurrencyList()
var mainCurrency =              fetchMainCurrency()
let accountsObjects =               fetchAccounts(accountType: 1)//.sorted(byKeyPath: "isMainAccount", ascending: false)//Card = 1
//let savingsObjects =              fetchAccounts(accountType: 2).sorted(byKeyPath: "date", ascending: false)//Cash = 2


let oneTimeObjects =            fetchSchedulers(scheduleType: 1).sorted(byKeyPath: "date", ascending: false)//OneTime = 1
let multiplyObjects =           fetchSchedulers(scheduleType: 2).sorted(byKeyPath: "date", ascending: true)//multiply =2
let regularObjects =            fetchSchedulers(scheduleType: 3).sorted(byKeyPath: "date", ascending: false)//Regular = 3
let goalObjects  =              fetchSchedulers(scheduleType: 4).sorted(byKeyPath: "date", ascending: false)//Goal   = 4

//let approachObjects =          fetchEntity(accountType: 1).sorted(byKeyPath: "date", ascending: false)//OperIncome
//let regularObjects =           fetchEntity(accountType: 2).sorted(byKeyPath: "date", ascending: false)//Regular = 2
//let debtObjects =              fetchEntity(accountType: 3).sorted(byKeyPath: "date", ascending: false)//Debt = 3

//let historyObjects =           outstanding(accountType: 8).sorted(byKeyPath: "date", ascending: false)//History = 8
var expenceObjects =            fetchCategories(categoryType: 1).sorted(byKeyPath: "position", ascending: false)//OperExpence
var incomeObjects =             fetchCategories(categoryType: 2).sorted(byKeyPath: "position", ascending: false)//OperIncome
let historyObjects =            realm.objects(AccountsHistory.self).sorted(byKeyPath: "date", ascending: false)
let payPerTimeObjects =         realm.objects(PayPerTime.self).sorted(byKeyPath: "date", ascending: true)
let currencyObjects =           realm.objects(CurrencyObject.self).sorted(byKeyPath: "ISO", ascending: false)
var userCurrencyObjects: [CurrencyObject] = []
var currencyNonPrioritiesObjects: [CurrencyObject] = []

var todayBalanceObject =        fetchTodayBalance()
///Меню в OperationViewController сегмент 1
///Operation Payment
var categoryGroup = [expenceObjects,incomeObjects]
///Operation Scheduler
var schedulerGroup = [oneTimeObjects,multiplyObjects,regularObjects,goalObjects]
///Меню в AccountsViewController
var accountsGroup = [accountsObjects]

func fetchPayPerTime() {
    
}

func getCurrenciesByPriorities(){
    var currencySortedArray: [CurrencyObject] = []
    var currencyNonPriority: [CurrencyObject] = []
    
    for i in currencyObjects {
        if i.ISOPriority != 15888 { // 15888 это дефолтное значение
            currencySortedArray.append(i)
        }else{
            if i.ISO == mainCurrency?.ISO{
                currencyNonPriority.insert(i, at: 0)
            }else if i.ISO == "USD"{
                currencyNonPriority.insert(i, at: 0)
            }else{
                currencyNonPriority.append(i)}
        }
    }
    
    currencyNonPrioritiesObjects = currencyNonPriority //.sorted(by: { $0.ISO < $1.ISO })
    userCurrencyObjects    = currencySortedArray.sorted(by: { $0.ISOPriority < $1.ISOPriority })
    
}
func containsISO(Iso: String) ->Bool {
    if currencyObjects.contains(where: { Object in
        Object.ISO == Iso
    }){
        return true
    }else{
        return false
    }
}


func addMainCurrencyForPriorityIfNeeded(mainISO: String){
    
    if userCurrencyObjects.contains(where: { Object in
        Object.ISO == mainISO
    }) {
    }else{
        for i in currencyObjects {
            if i.ISO == mainISO {
                try! realm.write {
                    i.ISOPriority = 0
                    realm.add(i,update: .all)
                }
            }
        }
    }
}
func fetchTodayBalance()-> TodayBalance? {
    
    
    return Array(realm.objects(TodayBalance.self)).first ?? nil
}


//Функция в любом случае достает основную валюту если та отсутствует, делает ее той которая в локализации и добавляет в список валют
func fetchMainCurrency() -> MainCurrency? {
    //Поверка на наличие валюты в списке валидных
    
    
    let object = realm.objects(MainCurrency.self)
    let locale = Locale.current.currencyCode
    var mainCurrency = MainCurrency() // USD by defauld
    var isPresent = false
    //Проверкаа валюты на наличии в списке выбраных
    for i in enumeratedALL(object: object){
        if containsISO(Iso: i.ISO) {
            isPresent = true
            break
        }else{
            try! realm.write{
                realm.delete(i)
            }
            continue
        }
    }
    //Если главная валюта вообще есть и она есть в списке
    if object.count != 0 && isPresent {
        for i in object {
            mainCurrency = i
        }
        addMainCurrencyForPriorityIfNeeded(mainISO: mainCurrency.ISO)
        return mainCurrency
    }else{
        if !currencyList.validISOList.contains(locale ?? "") {
            mainCurrency.ISO = "USD"
        }else{
            mainCurrency.ISO = locale!
        }
        try! realm.write {
            realm.add(mainCurrency)
        }
        addMainCurrencyForPriorityIfNeeded(mainISO: mainCurrency.ISO)
        return mainCurrency
    }
    
    
}
func removeWrongAccountISO() {
    let currentISO = Locale.current.currencyCode
    let objects = realm.objects(MonetaryAccount.self)
    for i in objects {
        
        if !currencyList.validISOList.contains(i.currencyISO) {
            try! realm.write {
                
                i.currencyISO = currentISO!
                realm.add(i,update: .all)
            }
            
        }
    }
}

func createAccountIfTheyAreMissing(accounts: Results<MonetaryAccount>) {
    if accounts.count == 0 {
        let account = MonetaryAccount()
        account.currencyISO = mainCurrency?.ISO ?? "USD"
        try! realm.write({
            realm.add(account)
        })
    }
}
func makeMainAccountIfNeeded(accounts: Results<MonetaryAccount>) {
    guard accounts.count > 0 else { return }
    if !accounts.contains(where: { account in
       return account.isMainAccount == true
    }){
            try! realm.write {
                 accounts[0].isMainAccount = true
                 realm.add(accounts[0],update: .all)
             }
    }
}

func fetchAccounts(accountType: Int) ->Results<MonetaryAccount>{
    let IntToString: String = String(accountType)
    removeWrongAccountISO()
    let objects = realm.objects(MonetaryAccount.self)
        .filter("accountType = \(IntToString)")
        .sorted(byKeyPath: "isMainAccount", ascending: false)
    createAccountIfTheyAreMissing(accounts: objects )
    makeMainAccountIfNeeded(accounts: objects)
    return objects
}

func fetchCategories(categoryType: Int) ->Results<MonetaryCategory> {
    let IntToString: String = String(categoryType)
    let object = realm.objects(MonetaryCategory.self).filter("categoryType = \(IntToString)")
    return object
}

func fetchSchedulers(scheduleType: Int) ->Results<MonetaryScheduler> {
    let intToString: String = String(scheduleType)
    let object = realm.objects(MonetaryScheduler.self).filter("scheduleType= \(intToString)")
    return object
}

