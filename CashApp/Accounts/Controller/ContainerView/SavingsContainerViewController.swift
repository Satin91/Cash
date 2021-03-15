//
//  BoxViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class SavingsContainerViewController: UIViewController {
    
    

   
    @IBOutlet var progressView: UIProgressView!
    var savingsModel: MonetaryAccount?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        progressView.progress = 0.6
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

     
    }
    
    
    



}
