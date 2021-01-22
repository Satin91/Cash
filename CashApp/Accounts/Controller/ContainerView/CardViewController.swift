//
//  scheduleViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    
    
    @IBOutlet var scheeduleText: UILabel!
    var scheduleModel: MonetaryAccount?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = whiteThemeBackground
        scheeduleText.text = scheduleModel?.name
    }
    



}
