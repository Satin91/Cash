//
//  scheduleViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import AAInfographics

class ContainerViewController: UIViewController {
  

    var destinationAccount: MonetaryAccount?
    static var destinationAccount: MonetaryAccount?
    
    var tableView: ChartsTableView!
    var isOperationDone = false //Булька для функции checkOperations
    //let textViewIfOperationIsntDone = UITextView() //Текст если не было операций на счете
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //sendCardNameDelegate.cardName(string: "sd")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Cardview did load")
        self.view.backgroundColor = .clear
       // textViewSettings()
        self.view.layer.cornerRadius = 18
        self.view.clipsToBounds = true
        tableView = ChartsTableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight] //Ресайз размеров для дочерних вью
        self.view.addSubview(tableView)
        
    }
//    func textViewSettings() {
//        textViewIfOperationIsntDone.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//        textViewIfOperationIsntDone.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        textViewIfOperationIsntDone.backgroundColor = whiteThemeBackground
//        textViewIfOperationIsntDone.font = UIFont(name: "SF Pro Text", size: 17)
//        textViewIfOperationIsntDone.textColor = whiteThemeTranslucentText
//        textViewIfOperationIsntDone.text = "A diagram of your transactions on this account will be displayed here, at the moment there are no transactions"
//    }

}
