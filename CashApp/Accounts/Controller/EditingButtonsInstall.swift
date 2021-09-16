//
//  EditingButtons.swift
//  CashApp
//
//  Created by Артур on 5.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
extension AccountsViewController {
    
    func buttonsColors() {
        
    }
    func createEditingButtons(isActive: Bool){
        activateButtons()
        
        stackViewForEditingButtons.axis = .horizontal
        stackViewForEditingButtons.distribution = .fillEqually
        stackViewForEditingButtons.alignment = .center
        stackViewForEditingButtons.spacing = 10
        stackViewForEditingButtons.addArrangedSubview(editingButtons.delete)
        stackViewForEditingButtons.addArrangedSubview(editingButtons.save)
        stackViewForEditingButtons.translatesAutoresizingMaskIntoConstraints = false
        editingButtons.delete.heightAnchor.constraint(equalToConstant: 46).isActive = true
        editingButtons.delete.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        editingButtons.save.heightAnchor.constraint(equalToConstant: 46).isActive = true
        editingButtons.save.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        self.view.addSubview(stackViewForEditingButtons)
        stackViewForEditingButtons.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackViewForEditingButtons.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor,constant: 50).isActive = true
        stackViewForEditingButtons.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 26).isActive = true
        stackViewForEditingButtons.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -26).isActive = true
        showHideBlur(isActive: isActive)
        isActive ? editingButtons.showButtons() : editingButtons.hideButtons()
    }
    
    func activateButtons(){
        editingButtons.setColors()
        editingButtons.delete.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        editingButtons.save.addTarget(self, action: #selector(saveAction(_:)), for: .touchUpInside)
    }
    
    @objc func deleteAction(_ sender: UIButton) {
        editableObject = nil
        
        try! realm.write({
            realm.delete(accountsObjects[visibleIndexPath.row] )
        })
        accountsCollectionView.deleteItems(at: [visibleIndexPath])
        
        accountsCollectionView.reloadData()
        selectedIndexPath = nil
        self.accountsCollectionView.deleteItems(at: [self.selectedIndexPath])
        
        accountsCollectionView.performBatchUpdates {
            self.accountsCollectionView.deleteItems(at: [selectedIndexPath])
        }completion: { comp in
            if comp {

            }
        }

            //return
           
      
      //  selectedIndexPath = nil
        
                       
                        
        
                    
//        self.addAlert(alertView: alertView, title: "Удалить счет?", message: "Счет будет удалет", alertStyle: .delete)
//        alertView.alertAction = { [weak self] (success) in
//
//        if success {
//
//
//                print("success")
//            self!.accountsCollectionView.performBatchUpdates {
//                self?.accountsCollectionView.deleteItems(at: [self!.visibleIndexPath])
//                try! realm.write {
//                    realm.delete(self!.editableObject!)
//                }
//
//            }
//
//
//
//            self!.accountsCollectionView.reloadData()
//            //self!.closeAlert(alertView: self!.alertView)
//        }else{
//
//
//            self!.closeAlert(alertView: self!.alertView)
//
//        }
//        }
    
    }
    @objc func saveAction(_ sender: UIButton) {
        
    }
    
    func showHideBlur(isActive: Bool){
        if isActive {
            UIView.animate(withDuration: 0.2) {[weak self] in
                self?.blurView.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.2) {[weak self] in
                self?.blurView.alpha = 0
            }
        }
    }
}
