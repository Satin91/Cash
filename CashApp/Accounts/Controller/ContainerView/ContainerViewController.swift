//
//  ContainerViewController.swift
//  CashApp
//
//  Created by Артур on 14.03.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    
    
    @IBOutlet var lineChartContainer: UIView!
    @IBOutlet var savingsContainer: UIView!
    
    @objc func receiveObject(_ notification: NSNotification) {
        
        let object = notification.object as! MonetaryAccount
        
        if object.accountType == AccountType.card.rawValue || object.accountType == AccountType.cash.rawValue  {
            lineChartContainer.isHidden = false
            savingsContainer.isHidden = true
        }else {
            lineChartContainer.isHidden = true
            savingsContainer.isHidden = false
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        savingsContainer.isHidden = true
        lineChartContainer.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(receiveObject), name: NSNotification.Name(rawValue: "MonetaryAccount"), object: nil)
        
        
    }
    


}
