//
//  SelectDateCalendarPopUpViewController.swift
//  CashApp
//
//  Created by Артур on 22.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
protocol closeSelectDateProtocol {
    func closeSelectDate(payPerTimeObject: PayPerTime)
}
class SelectDateCalendarPopUpTableViewController: UITableViewController,PopUpProtocol{
    func closePopUpMenu() {
        print("close")
    }
    
    var closeSelectDateDelegate: closeSelectDateProtocol!
    
    var payPerTimeObject: [PayPerTime]!
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            viewController.navigationItem.backBarButtonItem = item
        
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectDate Did load")
        navigationItem.setValue("Планы в этот день", forKey: "title")
        //tableView = UITableView(frame: .zero, style: .grouped)
//        self.view.addSubview(tableView)
//       // initConstraints(view: tableView, to: self.view)
        tableView.delegate = self
        tableView.dataSource = self
        let xibCell = UINib(nibName: "SelectDateTableViewCell", bundle: nil)
        
        tableView.register(xibCell, forCellReuseIdentifier: "SelectDateCell")
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payPerTimeObject.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDateCell") as! SelectDateTableViewCell
        let object = payPerTimeObject[indexPath.row]
        if payPerTimeObject != nil {
        
            cell.set(payPerTime: object)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = payPerTimeObject[indexPath.row]
        closeSelectDateDelegate.closeSelectDate(payPerTimeObject: object)
        dismiss(animated: true, completion: nil)
    }
}


    

