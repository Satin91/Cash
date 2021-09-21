//
//  CellClosures.swift
//  CashApp
//
//  Created by Артур on 16.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension AccountsViewController: MenuTableViewTappedDelegate {
    
    
    
    func setImageForAccount(image: String) {
        
        try! realm.write({
            let object = accountsObjects[visibleIndexPath.row]
            object.imageForAccount = image
            realm.add(object,update: .all)
        })
        guard let cell = accountsCollectionView.cellForItem(at: visibleIndexPath) as? AccountCollectionViewCell else { return }
        UIView.transition(with: cell.accountsImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { cell.accountsImageView.image = UIImage(named: image) },
                          completion: nil)
    }
    
    func makeTheMainAccount() {
        let visibleAccount = accountsObjects[visibleIndexPath.row]
        for accounts in Array(accountsObjects) where accounts.accountID != visibleAccount.accountID {
            try! realm.write({
                accounts.isMainAccount = false
                realm.add(accounts,update: .all)
            })
        }
        try! realm.write({
            visibleAccount.isMainAccount = true
            realm.add(visibleAccount,update: .all)
        })
        let clCell = accountsCollectionView.cellForItem(at: visibleIndexPath) as!AccountCollectionViewCell
        clCell.changeIsMainAccountLabelVisibility()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { // 0.3 Это скорость обновления menu table view после удаления ячейки "Сделать счет главным"
            self.accountsCollectionView.reloadData()
            self.accountsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0) , at: .centeredHorizontally, animated: false)
        })
        //self.willAccountBeMain = true // Переменная для уведомления коллекции что при закрытии меню нужно переместиться на нулевой индекс(где находится главный счет)
    }
    
    func openMenu(){
        editMode = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":true])
        //menuTableView.account = accountsObjects[visibleIndexPath.row]
        menuTableView.receiveAccount(isMain: accountsObjects[visibleIndexPath.row].isMainAccount)
        menuTableView.showMenuTableView()
        whetherToShowImageCollectionView(willShow: true)
        imageCollectionView.closure = { [weak self] ( image ) in
            guard let self = self else { return }
            self.setImageForAccount(image: image)
        }
        accountsCollectionView.isScrollEnabled = false
    }
    func closeMenu() {
        editMode = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":false])
        menuTableView.hideMenuTableView()
        whetherToShowImageCollectionView(willShow: false)
        editableObject = nil
        accountsCollectionView.isScrollEnabled = true
 
    }
    
    func designateTheNextAccountAsMain(deletionAccount: MonetaryAccount) {
        guard accountsObjects.count > 1 else { return }
        for (index,account) in accountsObjects.enumerated() {
            if account.isMainAccount {
                try! realm.write({
                    realm.delete(account) // удаление счета
                    let newMainAccount = accountsObjects[index] // Установка нового счета как главного по индексу удаленного
                    newMainAccount.isMainAccount = true
                    realm.add(newMainAccount,update: .all)
                })
                return
            }
        }
    }
    func deleteAccount(){
        
        let deletionAccount = accountsObjects[visibleIndexPath.row]
        if deletionAccount.isMainAccount == true {
        designateTheNextAccountAsMain(deletionAccount: deletionAccount)
        } else {
            try! realm.write({
                realm.delete(deletionAccount)
            })
        }
        self.accountsCollectionView.isScrollEnabled = true
        self.accountsCollectionView.performBatchUpdates {
            self.accountsCollectionView.deleteItems(at: [self.visibleIndexPath])
        } completion: { _ in
            self.scrollViewDidScroll(self.accountsCollectionView)//После удаления видимый индекс не обновляется, пришлось вызывать вручную
            self.closeMenu()
            self.accountsCollectionView.reloadData()
        }
        //        toggle = false // Это для того, чтобы кнопка редактирования не была активной у другого счета после удаления (после обновления коллекции метод cellforitem задает у ячейки свойство toggle - toggle этого класса) // В данный момент не работает
      
        
       // self.accountsCollectionView.reloadData()
    }
    
    func tappedForRow(action: MenuActions) {
        switch action {
        case .makeMain:
            makeTheMainAccount()
            // сделать главной
        case .delete:
            // удалить
            let commonAccountText = ["Удалить счет??","Счет будет удален но история останется"]
            let mainAccountText = ["Удалить главный счет??","Счет будет удален, главным будет назначен следующий по списку"]
            let isMainAccount = accountsObjects[visibleIndexPath.row].isMainAccount == true
                ? mainAccountText
                : commonAccountText
            self.alertView.showAlert(title: isMainAccount[0], message: isMainAccount[1], alertStyle: .delete)
            self.alertView.alertAction = { [weak self](success) in
                guard let self = self else  { return }
                if success {

                    self.deleteAccount()
                    self.alertView.closeAlert()

                }
            }
        }

    }
}
