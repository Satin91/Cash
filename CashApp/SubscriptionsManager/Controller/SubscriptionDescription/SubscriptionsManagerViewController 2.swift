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
    
    
    let colors = AppColors()
    let purchases = SubscriptionManager()

    @IBOutlet var subscriptionButton: UIButton!
    @IBAction func subscriptionButtonAction(_ sender: UIButton) {

    }
    // purchases.restorePurchases()
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var unlimitLabel: UILabel!
    @IBOutlet var unlimitDescription: UILabel!
    @IBOutlet var unlimitImageView: UIImageView!
    
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var notificationDescription: UILabel!
    @IBOutlet var notificationImageView: UIImageView!
    
    @IBOutlet var familyImageView: UIImageView!
    @IBOutlet var familyLabel: UILabel!
    @IBOutlet var familyDescription: UILabel!
    var navBarButtons: NavigationBarButtons!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colors.loadColors()
        setColors()
        visualSettings()
        setupNavBarButtons()
        setupLabels()
//        self.purchases.checkActiveEntitlement()
    }
    func setupLabels() {
        unlimitLabel.text            = NSLocalizedString("unlimit_header_label", comment: "")
        unlimitDescription.text      = NSLocalizedString("unlimit_descriptions", comment: "")
        notificationLabel.text       = NSLocalizedString("notifications_header_label", comment: "")
        notificationDescription.text = NSLocalizedString("notifications_descriptions", comment: "")
        familyLabel.text             = NSLocalizedString("family_header_label", comment: "")
        familyDescription.text       = NSLocalizedString("family_descriptions", comment: "")
        subscriptionButton.setTitle(NSLocalizedString("subscription_button_subscribe", comment: ""), for: .normal)
    }
    func setupNavBarButtons() {
        self.navBarButtons = NavigationBarButtons(navigationItem: navigationItem, leftButton: .none, rightButton: .cancel)
        self.navBarButtons.setRightButtonAction {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc private func didTapRestore(){
        
    }

 
}
