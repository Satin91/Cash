//
//  SelectDateCalendarPopUpViewController.swift
//  CashApp
//
//  Created by Артур on 22.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SelectDateCalendarPopUpViewController: UIViewController {
 
    var tableView: UITableView!
    
    var schedulerObject: MonetaryScheduler!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectDate Did load")
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
extension SelectDateCalendarPopUpViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if schedulerObject != nil {
        
        cell?.textLabel?.text = schedulerObject.name
        }
        return cell!
    }
    
    
    
}
