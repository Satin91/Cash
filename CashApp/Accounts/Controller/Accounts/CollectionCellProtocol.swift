//
//  CollectionCellProtocol.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
//MARK: Collection protocol

protocol collectionCellProtocol {
    func tapped(tapped: Bool)
    func cellTextFieldChanged(_ levelTableViewCell: AccountCollectionViewCell, didEndEditingWithText: String?, textFieldName: String!)
}

extension AccountsViewController: collectionCellProtocol {
    
    func cellTextFieldChanged(_ levelTableViewCell: AccountCollectionViewCell, didEndEditingWithText: String?, textFieldName: String!) {
        switch textFieldName {
        case "HeaderIsEditing":
            print("HeaderIsEditing")
            try! realm.write {
                visibleObject!.name = didEndEditingWithText!
            }
        case "BalanceIsEditing":
            print("BalanceIsEditing")
            try! realm.write {
                guard let sum = Double(didEndEditingWithText!) else {editableObject?.balance = 0; return} // Убирает nil если текст филд не дает никакого числа
                visibleObject!.balance = Double(sum)
                }
        default:
            break
        }
    }
    func showImageCollectionView(togle: Bool){
        
        if togle {
        UIView.animate(withDuration: 0.4) {
            self.imageCollectionView.alpha = 1
        }
        }else{
            UIView.animate(withDuration: 0.4) {
                self.imageCollectionView.alpha = 0
            }
        }
    }
 
    func tapped(tapped: Bool) {
        toggle.toggle()
        switch toggle {
        case false: // Не в режиме редактирования
            // Инициализировали редактирование
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":false])
            editableObject = nil
            selectedIndexPath = nil
            accountsCollectionView.isScrollEnabled = true
            accountsCollectionView.reloadData()
            menu.hideMenu()
            // Вытащил объект по индексу
           // selectedObject = EnumeratedAccounts(array: accountsGroup)[selectedIndexPath.row]
            // Сменил констрейнт и переместился к текущему изображению в редакторе
            
           // changeConstraint()
            showImageCollectionView(togle: false)
          //  createEditingButtons(isActive: false)
        //    toggle.toggle()
            //accountsCollectionView.isScrollEnabled = true
         //   accountsCollectionView.reloadData()
        case true: // В режиме редактирования
            
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":true])
           // selectedIndexPath = IndexPath(item: 0, section: 0)  //visibleIndexPath
            
            editableObject = accountsObjects[visibleIndexPath.row]
            
            menu.showMenu(account: editableObject)
            showImageCollectionView(togle: true)
            imageCollectionView.account = editableObject
            accountsCollectionView.reloadData()
            //editableObject = accountsObjects[selectedIndexPath.row]
            //imageCollectionView.account = editableObject
            accountsCollectionView.isScrollEnabled = false
          //  createEditingButtons(isActive: true)
            
            
         //   toggle.toggle()
            //changeConstraint()
            // Вернул индекс в доВыбранное состояние птмчто возвращает текущий видимый и при новом нажатии на редактор возвращает нил
            //visibleIndexPath = selectedIndexPath
            
            
        }
    }
    
}
