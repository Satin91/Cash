//
//  CellClosures.swift
//  CashApp
//
//  Created by Артур on 16.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension AccountsViewController {
    
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
       
        
        //accountsCollectionView.reloadData()
     
        
    }
    
    func openMenu(){
        toggle = true
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":true])
    showImageCollectionView(togle: true)
        imageCollectionView.closure = { [weak self] ( image ) in
           guard let self = self else { return }
            self.setImageForAccount(image: image)
            
        }
    accountsCollectionView.isScrollEnabled = false
}
func closeMenu() {
    toggle = false
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":false])
    
    showImageCollectionView(togle: false)
    editableObject = nil
    accountsCollectionView.isScrollEnabled = true
    accountsCollectionView.reloadData()
    showImageCollectionView(togle: false)
}
    func removeAccount(){
        
    }
}
