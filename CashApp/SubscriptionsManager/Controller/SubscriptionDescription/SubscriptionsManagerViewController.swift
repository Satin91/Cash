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
    
    
    var cancelButtom: CancelButton!
    let colors = AppColors()
    let purchases = SubscriptionManager()

    @IBOutlet var subscriptionButton: UIButton!
    @IBAction func subscriptionButtonAction(_ sender: UIButton) {

    }
    @IBOutlet var restoreButtonOutlet: UIButton!
    @IBAction func restoreButtonAction(_ sender: UIButton) {
        purchases.restorePurchases()
    }
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var unlimitLabel: UILabel!
    @IBOutlet var unlimitDescription: UILabel!
    @IBOutlet var unlimitImageView: UIImageView!
    
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var notificationDescription: UILabel!
    
    @IBOutlet var notificationImageView: UIImageView!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColors()
        createCancelButton()
        visualSettings()
//        self.purchases.checkActiveEntitlement()
    }

    @objc private func didTapRestore(){
        
    }

    

    func createCancelButton() {
        cancelButtom = CancelButton(frame: .zero, title: .cancel, owner: self)
        cancelButtom.addToParentView(view: self.view)
    }
 
}
