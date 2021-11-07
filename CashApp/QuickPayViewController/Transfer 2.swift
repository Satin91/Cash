//
//  SendOrReceive.swift
//  CashApp
//
//  Created by Артур on 18.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class Transfer {
    
    
    private let currencyController = CurrencyModelController()
    
    
    //Описание функции: Переданный счет выраженный структурой transfer model в любом случае работает с sumTextField, по этому в сторону сотрудничающего счета конвертируется введенная сумма. Пополнение или отправка не имеет значения. В конце поставил оператор guard чтобы не произвелась запись временного счета ( without account object ) который имеет идентификатор "NO ACCOUNT"
    func saveTransfer(transferredObject: TransferModel,cooperatingAccount: MonetaryAccount, enteredSum: Double, historyObject: AccountsHistory, createHistory: Bool) {
        
        let convertedSum = currencyController.convert(enteredSum, inputCurrency: transferredObject.account.currencyISO , outputCurrency: cooperatingAccount.currencyISO)
        print("Converted Sum is \(convertedSum)")
        try! realm.write({
            switch transferredObject.transferType {
            case .receive:
                cooperatingAccount.balance -= convertedSum!
                transferredObject.account.balance += enteredSum
            case .send:
                cooperatingAccount.balance += convertedSum!
                transferredObject.account.balance -= enteredSum
            }
            realm.add(transferredObject.account,update: .all)
            
            if createHistory == true { // Этот метод так же используется в методе изменения истории, где повторно создавтать объект истории не требуется
                saveTransferHistory(transferObject: transferredObject, cooperatingAccount: cooperatingAccount, enteredSum: enteredSum, historyObject: historyObject)
            }
          
            
            guard cooperatingAccount.accountID != "NO ACCOUNT" else { return }
            realm.add(cooperatingAccount,update: .all)
        })
        
        
    }
    private func saveTransferHistory(transferObject: TransferModel,cooperatingAccount: MonetaryAccount,enteredSum: Double, historyObject: AccountsHistory){
        
        historyObject.name = transferObject.account.name
        historyObject.accountID = transferObject.account.accountID
        historyObject.secondAccountID = cooperatingAccount.accountID
        historyObject.accountName = transferObject.account.name
        historyObject.secondAccountName = cooperatingAccount.name
        historyObject.image = transferObject.transferType.image
        realm.add(historyObject)//Данный метод находится в области записи, по этому нужно без try
    }
    
}
