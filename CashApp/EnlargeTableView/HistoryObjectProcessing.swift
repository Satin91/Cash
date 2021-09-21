//
//  HistoryObjectProcessing.swift
//  CashApp
//
//  Created by Артур on 20.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class HistoryObjectProcessing {
    
    var historyObject: AccountsHistory!
    init(historyObject: AccountsHistory) {
        self.historyObject = historyObject
    }
    
    func findTheAccountIn(accountID: String, historyObject: AccountsHistory){
        var account: MonetaryAccount?
        
        for i in accountsObjects {
            if accountID == i.accountID{
                account = i
            }
        }
        try! realm.write {
            guard let acc = account else {
                realm.delete(historyObject)
                return
            }
            acc.balance -= historyObject.sum
            realm.add(acc,update: .all)
            realm.delete(historyObject)
        }
    }
    
    //MARK: RemoveData
    typealias TransferAccounts = (transferObject: MonetaryAccount?,cooperatingAccount: MonetaryAccount?)
    
    private func findOutAccounts() -> ((TransferAccounts),(Bool)) {
        var transferObject: MonetaryAccount? // может отсутствовать если был удален
        var cooperatingAccount: MonetaryAccount? // может отсутствовать при выборе "без счета"
        
        for i in accountsObjects {
            if self.historyObject.accountID == i.accountID {
                transferObject = i
            } else if self.historyObject.secondAccountID == i.accountID {
                cooperatingAccount = i
            }
        }
        if transferObject == nil && cooperatingAccount == nil {
            return ((transferObject,cooperatingAccount),false)
        } else {
            return ((transferObject,cooperatingAccount),true)
        }
    }
    
    
    func removeTransferObject() {
        //Если оба объекта отсутствуют - просто удалить объект истории
        guard findOutAccounts().1 == true else {
            try! realm.write({
                realm.delete(self.historyObject)
            })
            return
        }
        let transferObjects = findOutAccounts().0
        try! realm.write({
            if transferObjects.transferObject != nil {
                recoverTransferObject(transferObjects.transferObject!)
            }
            if transferObjects.cooperatingAccount != nil {
                recoverCooperatingAccount(transferObjects.cooperatingAccount!)
            }
            realm.delete(self.historyObject)
        })
    }
    
    //Метод запускается в режиме записи рилма
    private func recoverTransferObject(_ transferObject: MonetaryAccount) {
        let sumWithoutHundredthsAtTheEnd = (transferObject.balance - self.historyObject.sum).removeHundredthsFromEnd()
        transferObject.balance = sumWithoutHundredthsAtTheEnd
        realm.add(transferObject,update: .all)
        
    }
    //Метод запускается в режиме записи рилма
    private func recoverCooperatingAccount(_ cooperatingAccount: MonetaryAccount) {
        let sumWithoutHundredthsAtTheEnd = historyObject.convertedSum == 0
            ? cooperatingAccount.balance + historyObject.sum
            : cooperatingAccount.balance + historyObject.convertedSum
        cooperatingAccount.balance = sumWithoutHundredthsAtTheEnd.removeHundredthsFromEnd()
//        
//        if historyObject.convertedSum == 0 {
//            cooperatingAccount.balance += historyObject.sum.removeHundredthsFromEnd()
//        } else {
//            cooperatingAccount.balance += historyObject.convertedSum.removeHundredthsFromEnd()
//        }
        realm.add(cooperatingAccount, update: .all)
    }
}
