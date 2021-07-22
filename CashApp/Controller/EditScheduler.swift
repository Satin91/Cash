//
//  EditScheduler.swift
//  CashApp
//
//  Created by Артур on 7.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit


extension AddScheduleViewController {
    
    func setDataFromEditableObject(){
        
        nameTextField.text = newScheduleObject.name
        sumPerTimeTextField.text = newScheduleObject.sumPerTime.formattedWithSeparator
        totalSumTextField.text = (newScheduleObject.target - newScheduleObject.available).formattedWithSeparator
        
        selectImageButtonOutlet.setImage(UIImage(named: newScheduleObject.image), for: .normal)
        date = newScheduleObject.date
        vector = newScheduleObject.vector
        dateRhythm = newScheduleObject.stringDateRhythm
        selectedImageName = newScheduleObject.image
        currency = newScheduleObject.currencyISO
        if vector {
            incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
            expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
        }else{
            expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
            incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
        }
        
        if newScheduleObject.stringScheduleType == .regular || newScheduleObject.stringScheduleType == .multiply {
            var payArray:[PayPerTime] = []
            for pay in payPerTimeObjects {
                if newScheduleObject.scheduleID == pay.scheduleID {
                    payArray.append(pay)
                }
            }
            payArray.sort(by: {$0.date > $1.date})
            date = payArray.first?.date
        }else if newScheduleObject.stringScheduleType == .goal {
            sumPerTimeTextField.text = newScheduleObject.available.formattedWithSeparator
            totalSumTextField.text = newScheduleObject.target.formattedWithSeparator
        }
        selectDateButtonOutlet.setTitle(fullDateToString(date: date), for: .normal)
        
    }
    
    func removeAllPayPerTimeFromScheduler(){
        var payArr: [PayPerTime] = []
        for pay in payPerTimeObjects {
            if newScheduleObject.scheduleID == pay.scheduleID{
                payArr.append(pay)
            }
            
        }
        try! realm.write {
            realm.delete(payArr)
        }
    }
    
    func saveAndCloseScheduler() {
        var account: MonetaryAccount?
       // let sum = sumPerTime - newScheduleObject.available
        for i in accountsObjects {
            if i.isMainAccount {
                account = i
            }
        }
        account = account ?? MonetaryAccount(name: "QSGHNDHDSGHJ", balance: 0, targetSum: 0, date: nil, imageForAccount: "card", imageForCell: "card", accountType: .none, currencyISO: mainCurrency!.ISO, isMainAccount: false, isUseForTudayBalance: false)
        for i in EnumeratedSchedulers(object: schedulerGroup) {
            if i.scheduleID == newScheduleObject.scheduleID {
                try! realm.write {
                    
//                    let historyObject = AccountsHistory(name: i.name, accountID: account!.accountID, categoryID: "", scheduleID: i.scheduleID, payPerTimeID: "", sum: vector ? sum : -sum, convertedSum: (currencyModelController.convert(sum , inputCurrency: i.currencyISO, outputCurrency: account?.currencyISO)?.removeHundredthsFromEnd())!, date: Date(), currencyISO: i.currencyISO, image: i.image)
                   
//                    account?.balance -= vector ? -historyObject.convertedSum : historyObject.convertedSum
//                    if account?.name != "QSGHNDHDSGHJ" {
//                        realm.add(account!,update: .all)
//                    }
                    //realm.add(historyObject)
                    
                    realm.delete(i)
                    
                    
                }
            }
        }
    }
    
}
