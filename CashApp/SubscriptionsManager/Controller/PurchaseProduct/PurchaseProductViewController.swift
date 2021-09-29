//
//  ProductViewController.swift
//  CashApp
//
//  Created by Артур on 24.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Purchases

class PurchaseProductViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let purchases = SubscriptionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension PurchaseProductViewController: UITableViewDelegate, UITableViewDataSource {
    
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTableViewCell", for: indexPath) as! SubscriptionTableViewCell
        cell.selectionStyle = .blue
        if indexPath.row == 0 {
            cell.textLabel?.text = "Месяц"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Год"
        }
        cell.textLabel?.font = .systemFont(ofSize: 26, weight: .medium)
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        purchases.fetchOfferingPackage(packageIndex: indexPath.row) { prchs in
            self.purchases.purchase(package: prchs)
        }
    }
}
