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

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nController = self.navigationController else{return}
        setupNavigationController(Navigation: nController)
        print(boxObjects)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EnumeratedSequence(array: accountsObjects).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.totalBalanceIdentifier, for: indexPath) as! TableViewCell
        let object = EnumeratedSequence(array: accountsObjects)[indexPath.row]
        cell.set(object: object)
        cell.selectionStyle = .none
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let totalBalanceDetailVC = segue.destination as! AccountsDetailViewController
            guard let indexPath = accountsTableView.indexPathForSelectedRow else{return}
            let entity = EnumeratedSequence(array: accountsObjects)[indexPath.row]
            //Передаем модель для дальнейшей обработки
            totalBalanceDetailVC.entityModel = entity
        }
    }
}
