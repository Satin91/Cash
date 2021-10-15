//
//  QuickPayAccountsTableView.swift
//  CashApp
//
//  Created by Артур on 14.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension QuickPayViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Убирает счет, если была произведена операция перевода (Transfer) и убрать заблокированные счета
     func exclude( _ account: String, from: inout [MonetaryAccount]) {
         var object: MonetaryAccount!
         
         from.forEach { acc in
             if acc.accountID == account {
                 object = acc
             }
         }
        for (index,value) in from.enumerated() {
            if object == value {
                from.remove(at: index)
            }
        }
    }
    // Создает массив счетов включая "Без счета"
    func accountsWithWithoutAccount() -> [MonetaryAccount] {
        //var object: Any? = nil
        var accounts = EnumeratedAccounts(array: accountsGroup).filter { acc in
            acc.isBlock == false
        }
        
        accounts.append(withoutAccountObject)
        switch payObject {
        case is TransferModel:
           let object = payObject as! TransferModel
            exclude(object.account.accountID, from: &accounts)
        case is AccountsHistory:
           let object = payObject as! AccountsHistory
            if object.secondAccountID != "" {
                exclude(object.accountID, from: &accounts)
            }
        default:
            break
        }
       
        return accounts
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func getSelectedIndex() -> Int {
        var counter: Int = 0
        for i in accountsWithWithoutAccount() {
            
            if selectedAccountObject!.accountID == i.accountID {
                return counter
            } else {
                counter += 1
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsWithWithoutAccount().count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.selectRow(at: IndexPath(row: getSelectedIndex(), section: 0), animated: false, scrollPosition: .none)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = accountsWithWithoutAccount()[indexPath.row]
        if indexPath.row == accountsWithWithoutAccount().count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WithoutAccountCell", for: indexPath) as! WithoutAccountTableViewCell
            cell.label.text = object.name
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuickTableViewCell", for: indexPath) as! QuickTableVIewCell
            cell.set(object: object)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = accountsWithWithoutAccount()[indexPath.row]
        guard object != accountsWithWithoutAccount().last else {
            selectedAccountObject = withoutAccountObject
            accountLabel.text = selectedAccountObject?.name
            convertedSumLabel.isHidden = true // Скрывает конвертер чтобы не показывал ненужную конвертацию ( по умолчанию у withoutObject стоит ISO USD если нет главной валюты)
            returnToCenter.returnToCenterWithDelay(scrollView: self.scrollView)
            return}
        
        convertedSumLabel.isHidden = false // Возвращает видение если то было скрыто
        selectedAccountObject = object
        accountLabel.text = object.name
        self.observeConvertedSum()
        returnToCenter.returnToCenterWithDelay(scrollView: self.scrollView)
    }
   
}
