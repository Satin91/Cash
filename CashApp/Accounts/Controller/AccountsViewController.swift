//
//  TotalBalanceViewController.swift
//  CashApp
//
//  Created by Артур on 9/27/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var accountsTableView: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        //addVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pickTypeVC = storyboard.instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpViewController
        let navVC = UINavigationController(rootViewController: pickTypeVC)
        pickTypeVC.buttonsNames = ["Card","Cash","Savings"]
        pickTypeVC.goingTo = "addAccountVC"
        navVC.modalPresentationStyle = .pageSheet
        //Передача данных описана в классе PickTypePopUpViewController
        present(navVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nController = self.navigationController else{return}
        setupNavigationController(Navigation: nController)
        //print(boxObjects)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EnumeratedAccounts(array: accountsObjects).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.totalBalanceIdentifier, for: indexPath) as! TableViewCell
        let object = EnumeratedAccounts(array: accountsObjects)[indexPath.row]
        cell.setAccount(object: object)
        cell.selectionStyle = .none
        cell.userImage.setImageColor(color: whiteThemeMainText)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let accountsDetailViewController = segue.destination as! AccountsDetailViewController
            guard let indexPath = accountsTableView.indexPathForSelectedRow else{return}
            let entity = EnumeratedAccounts(array: accountsObjects)[indexPath.row]
            //Передаем модель для дальнейшей обработки
            accountsDetailViewController.entityModel = entity
        }
    }
}
