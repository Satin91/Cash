//
//  ChangeHistoryObject.swift
//  CashApp
//
//  Created by Артур on 30.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import RealmSwift

class ChangeHistoryObject {
    
    var oldhistoryObject: AccountsHistory
    var processing: HistoryObjectProcessing!
    let transfer = Transfer()
    let currencyController = CurrencyModelController()
    init(historyObject: AccountsHistory) {
        self.oldhistoryObject = historyObject
        processing = HistoryObjectProcessing(historyObject: self.oldhistoryObject)
    }
    
    
    
    func getAccount(historyObject: AccountsHistory) -> MonetaryAccount {
        var account: MonetaryAccount?
        accountsObjects.forEach { acc in
            if historyObject.accountID == acc.accountID {
                account = acc
            }
        }
        let withoutAccount = MonetaryAccount()
        withoutAccount.accountID = "NO ACCOUNT"
        return account ?? withoutAccount
    }
    
    func changeTransferValues(transferObject: MonetaryAccount, cooperatingObject:MonetaryAccount, newHistory: AccountsHistory) {
        let sum = abs(newHistory.sum)
        let convSum = currencyController.convert(sum, inputCurrency: transferObject.currencyISO, outputCurrency: cooperatingObject.currencyISO)
        let vector: TransferType = oldhistoryObject.sum > 0 ? .receive : .send
        
        try! realm.write({
            switch vector {
            case .receive:
                transferObject.balance += sum
                realm.add(transferObject, update: .all)
                guard cooperatingObject.accountID != "NO ACCOUNT" else { return }
                cooperatingObject.balance -= convSum!
                realm.add(cooperatingObject, update: .all)
            case .send :
                transferObject.balance -= sum
                realm.add(transferObject, update: .all)
                guard cooperatingObject.accountID != "NO ACCOUNT" else { return }
                cooperatingObject.balance += convSum!
                realm.add(cooperatingObject, update: .all)
            }
        })
        
    }
    // посли этой функции в классе стоит Return что не дает дальше работать с объектом истории
    func makeHistoryChanges(newHistoryObject: AccountsHistory) {
        if oldhistoryObject.secondAccountID.isEmpty == false { // Так мы поняли что имеем дело с трансфером
            processing.removeTransferObject(withHistory: false) // Вернул первоначальные объекты к первоначальному состоянию
            let transfer = processing.findOutAccounts() // Получили первоначальные 2 объекта истории
            self.changeTransferValues(transferObject: transfer.0.transferObject!, cooperatingObject: getAccount(historyObject: newHistoryObject), newHistory: newHistoryObject)
            self.replaceOldHistoryForTransfer(old: oldhistoryObject, new: newHistoryObject)
        } else {
            try! realm.write({
                let oldAccount = getAccount(historyObject: oldhistoryObject)
                let newAccount = getAccount(historyObject: newHistoryObject)
                if oldAccount.accountID != "NO ACCOUNT" {
                    //oldAccount.balance -= oldhistoryObject.sum
                    oldAccount.balance -= (hasAmountBeenConverded(object: oldhistoryObject) == true) // Проверка: была ли сконвертирована ли сумма
                    ? oldhistoryObject.convertedSum
                    : oldhistoryObject.sum
                    realm.add(oldAccount, update: .all)
                }
                if newAccount.accountID != "NO ACCOUNT" {
                    newAccount.balance += (hasAmountBeenConverded(object: newHistoryObject) == true) // Проверка: была ли сконвертирована ли сумма
                    ? newHistoryObject.convertedSum
                    : newHistoryObject.sum
                    realm.add(newAccount,update: .all)
                }
            })
            replaceOldHistory(old: oldhistoryObject, new: newHistoryObject)
        }
        
    }
    
    func replaceOldHistoryForTransfer(old: AccountsHistory, new: AccountsHistory) {
        try! realm.write({
            
            old.sum = new.sum
            old.convertedSum = new.convertedSum
            old.secondAccountID = new.accountID // Сделано так, потому что в контроллере можно выбрать только 1 аккаунт и это accountID
            old.date = new.date
            realm.add(old,update: .all)
        })
    }
    // Находится в области видимостри Try realm
    func replaceOldHistory(old: AccountsHistory, new: AccountsHistory) {
        try! realm.write({
            if old.scheduleID == "" { // Нельзя менять валюту в оъекте плана иначе происходит неверная конвертация
                old.currencyISO = new.currencyISO
            }
            old.accountID = new.accountID
            old.sum = new.sum
            old.accountName = new.accountName
            old.convertedSum = new.convertedSum
            old.date = new.date
            realm.add(old,update: .all)
        })
    }
    // Если сконвертированная сумма не равна 0 вернуть обычную сумму, если нет, вернуть сконвертированнную
    // If history object is scheduler object
    // 1 - вернуть сконвертированную сумму счету
    // 2 - при удалении так же вернуть сконвертированную сумму счета
    // 3 - Не менять сумму платежа
    
    func hasAmountBeenConverded(object: AccountsHistory) -> Bool {
        if object.convertedSum != 0 {
            return true
        } else {
            return false
        }
    }
}

/*
 Требуется :
 1: Проверка на присутствие счет с которым совершали операции
 2: Сравнить 2 истории и сделать по шаблону
 */
