//
//  SelectDateCalendarPopUpViewController.swift
//  CashApp
//
//  Created by Артур on 22.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
protocol CloseSelectDateProtocol {
    func closeSelectDate(payObject: Any)
}
class SelectDateCalendarPopUpTableViewController: UITableViewController{

    //Протокол который отправляет назад выбранные данные
    var closeSelectDateDelegate: CloseSelectDateProtocol!
    var payObject: [Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectDate Did load")
        navigationItem.setValue("Планы в этот день", forKey: "title")
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


    

