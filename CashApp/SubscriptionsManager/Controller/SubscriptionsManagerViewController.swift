//
//  SubscriptionsManagerViewController.swift
//  CashApp
//
//  Created by Артур on 21.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import StoreKit
import Purchases

class SubscriptionsManagerViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let notificationCenter = NotificationCenter.default
    var cancelButtom: CancelButton!
    let colors = AppColors()
    
    private let subscribeButton: UIButton = {
       let button = UIButton()
        button.frame = CGRect (x: 50, y: 50, width: 160, height: 60)
        button.backgroundColor = .systemGreen
        button.setTitle("Subscribe", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.isHidden = true
        return button
    }()

    private let restorePurchase: UIButton = {
       let button = UIButton()
        button.frame = CGRect (x: 50, y: 150, width: 160, height: 60)
        button.backgroundColor = .systemGray
        button.setTitle("Restore", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setColors()
        createCancelButton()
        self.view.addSubview(subscribeButton)
        self.view.addSubview(restorePurchase)
        self.subscribeButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
        self.restorePurchase.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
        setUp()
    }
    
    
    
    @objc private func didTapSubscribe(){
        fetchPackage { [weak self] package in
            guard let self = self else { return }
            self.purchase(package: package)
        }
    }
    
    @objc private func didTapRestore(){
        
    }
    
    func setUp() {
        
        Purchases.shared.purchaserInfo { [weak self]info, error in
            guard let info = info, error == nil else { return }
            guard let self = self else { return }
            if info.entitlements.all[""]?.isActive == true {
                
            } else {
                DispatchQueue.main.async {
                    self.subscribeButton.isHidden = false
                    self.restorePurchase.isHidden = false
                }
            }
        }
    }
    
    func fetchPackage(completion: @escaping(Purchases.Package) -> Void ) {
        Purchases.shared.offerings { offerings, error in
            guard let offerings = offerings, error == nil else {return }
          
            guard let package = offerings.all.first?.value.availablePackages.first else {
                return
            }
            completion(package)
    }
    }
    func purchase(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
            guard let transactions = transaction,
                  let info = info,
                  error == nil,
                  !userCancelled else {
                return
            }
            
            print(transactions.transactionState)
            print(info.entitlements)
        }
    }
    
    func retorePurchases() {
        Purchases.shared.restoreTransactions { info, error in
            guard let info = info, error == nil else { return }
        }
    }
    

    func createCancelButton() {
        cancelButtom = CancelButton(frame: .zero, title: .cancel, owner: self)
        cancelButtom.addToParentView(view: self.view)
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    private func priceStringFor(product: SKProduct)-> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)!
    }

}
extension SubscriptionsManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTableViewCell", for: indexPath) as! SubscriptionTableViewCell
        cell.selectionStyle = .blue
     
        cell.textLabel?.font = .systemFont(ofSize: 26, weight: .medium)
       
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
