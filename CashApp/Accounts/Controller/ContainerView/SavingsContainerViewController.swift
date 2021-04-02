//
//  BoxViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class SavingsContainerViewController: UIViewController {
    
  
    @IBOutlet var progressBar: ProgressBar!
    
    var savingsModel: MonetaryAccount?
    var subView = NeoView()
    @IBOutlet var progressLabel: UILabel!
    @objc func receiveObject(_ notification: NSNotification) {
        guard let object = notification.object as? MonetaryAccount else {return}
        savingsModel = object
        print(object)
        
        labelSettings(label: progressLabel)
        
        let percent = (savingsModel!.balance / savingsModel!.targetSum) * 100
        let s = String(format: "%.0f", Double((savingsModel!.balance / savingsModel!.targetSum) * 100))
        progressBar.progress = CGFloat(savingsModel!.balance / savingsModel!.targetSum)
        progressLabel.text = "\(s) %"
    }
    
    func labelSettings(label: UILabel) {
        label.textColor = whiteThemeMainText
        label.text = savingsModel?.name
        label.font = .systemFont(ofSize: 75)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        subView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(subView)
        self.view.sendSubviewToBack(subView)
        self.view.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveObject(_:)), name: NSNotification.Name(rawValue: "ContainerObject"), object: nil)
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    
    



}
