//
//  LoadMenu.swift
//  CashApp
//
//  Created by Артур on 16.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupMenu() {
        let frameTableView = CGRect (x: 26, y: self.view.bounds.height - 60 * 3, width: self.view.bounds.width - 26 * 2, height: 60 * 3)
        menuTableView = MenuTableView(frame: frameTableView, style: .plain)
        menuTableView.delegate = self
        menuTableView.dataSource = self
        self.view.addSubview(menuTableView)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        guard visibleIndexPath != nil else {return cell}
        let object = accountsObjects[visibleIndexPath.row]
        switch indexPath.row {
        case 0:
            cell.menuImage.image = UIImage(named: object.currencyISO)
            cell.menuLabel.text = "Change currency"
            return cell
        case 1:
            cell.menuImage.image = UIImage(named: "makeMainAccount")
            cell.menuLabel.text = "Make main account"
            return cell
        case 2:
           
            cell.menuImage.image = UIImage(named: "deleteAccount")
            cell.menuLabel.text = "Delete"
            return cell
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 2 {
            editableObject = nil
            
            alertView.showAlert(title: "Удалить счет??", message: "Счет будет удален но история останется", alertStyle: .delete)
            
            alertView.alertAction = { [weak self](success) in
                guard let self = self else  { return }
                if success {
                    
                    try! realm.write({
                        realm.delete(accountsObjects[self.visibleIndexPath.row])
                    })
                    self.accountsCollectionView.deleteItems(at: [self.visibleIndexPath])
                    self.toggle = false
                    self.closeMenu()
                    self.accountsCollectionView.isScrollEnabled = true
                    self.showImageCollectionView(togle: false)
                    self.accountsCollectionView.reloadData()
                }
            }
        }
    }
    
    
    
    
}
