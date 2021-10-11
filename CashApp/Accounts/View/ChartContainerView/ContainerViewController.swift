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
    
    //var monetaryAccount: MonetaryAccount?
    
    func animateContainer(object: MonetaryAccount) {
        UIView.animate(withDuration: 0.1) {
            self.lineChartContainer.alpha = 0
        } completion: { (true) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContainerObject"), object: object)
            
            UIView.animate(withDuration: 0.1) {
                    self.lineChartContainer.alpha = 1
            }
        }
    }
    
    
    @objc func receiveObject(_ notification: NSNotification) {
        let object = notification.object as! MonetaryAccount
        animateContainer(object: object)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveObject), name: NSNotification.Name(rawValue: "MonetaryAccount"), object: nil)
        self.view.backgroundColor = .clear
        savingsContainer.alpha = 0
        lineChartContainer.alpha = 0
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
