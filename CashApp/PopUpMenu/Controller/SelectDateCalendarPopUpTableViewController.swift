//
//  SelectDateCalendarPopUpViewController.swift
//  CashApp
//
//  Created by Артур on 22.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
protocol closeSelectDateProtocol {
    func closeSelectDate(payObject: Any)
}
class SelectDateCalendarPopUpTableViewController: UITableViewController,PopUpProtocol{
    func closePopUpMenu() {
        print("close")
    }
    
    var closeSelectDateDelegate: closeSelectDateProtocol!
    
    var payObject: [Any]!
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            let item = UIBarButtonItem(title: "YAYA", style: .plain, target: nil, action: nil)
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
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return payObject.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDateCell") as! SelectDateTableViewCell
        
        let object = payObject[indexPath.row]
        if payObject != nil {
            cell.set(object: object)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object = payObject[indexPath.row]
        
   
        closeSelectDateDelegate.closeSelectDate(payObject: object)
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


    

