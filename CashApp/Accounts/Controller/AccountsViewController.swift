//
//  TotalBalanceViewController.swift
//  CashApp
//
//  Created by Артур on 9/27/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit


class AccountsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,dismissVC {
    
    var accountsLabelsNames = ["Add","card","cash","savings"]
    var bottomLabelText = ["to accounts","to schedule","category"]
    
    
    func dismissVC(goingTo: String,restorationIdentifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addAccountVC = storyboard.instantiateViewController(identifier: "addAccountVC") as! AddAccountViewController
        if goingTo == "addAccountVC" {
            switch restorationIdentifier {
            case "upper":
                addAccountVC.newAccount.stringAccountType = .card
                addAccountVC.textForMiddleLabel = accountsLabelsNames[1]
            case "middle":
                addAccountVC.newAccount.stringAccountType = .cash
                addAccountVC.textForMiddleLabel = accountsLabelsNames[2]
            case "bottom":
                addAccountVC.newAccount.stringAccountType = .box
                addAccountVC.textForMiddleLabel = accountsLabelsNames[3]
            default:
                return
            }
            addAccountVC.textForUpperLabel = accountsLabelsNames[0]  // Здесь 0 для удобства т.к. модель начинается с единицы
            addAccountVC.textForBottomLabel = bottomLabelText[0]
        }
        let navVC = UINavigationController(rootViewController: addAccountVC)
        navVC.modalPresentationStyle = .pageSheet
        
        present(navVC, animated: true)
    }
    
    
    @IBOutlet var accountsTableView: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        //addVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pickTypeVC = storyboard.instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpViewController
        let navVC = UINavigationController(rootViewController: pickTypeVC)
        pickTypeVC.buttonsNames = ["Card","Cash","Savings"]
        pickTypeVC.goingTo = "addAccountVC"
        pickTypeVC.delegate = self
        navVC.modalPresentationStyle = .pageSheet
        // Передача данных описана в классе PickTypePopUpViewController
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
    @IBAction func unwindSegueToAccountsVC(_ segue: UIStoryboardSegue){
        accountsTableView.reloadData()
    }
}
