//
//  SelectDateCalendarPopUpViewController.swift
//  CashApp
//
//  Created by Артур on 22.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
protocol ClosePopUpTableViewProtocol {
     func closeTableView(object: Any)
}


class PopTableViewController: UITableViewController{

    //Протокол который отправляет назад выбранные данные
    var closeSelectDateDelegate: ClosePopUpTableViewProtocol!
    var payObject: [Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectDate Did load")
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.delegate = self
        tableView.dataSource = self
        let xibCell = UINib(nibName: "SelectDateTableViewCell", bundle: nil)
        tableView.register(xibCell, forCellReuseIdentifier: "SelectDateCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if payObject.first is IndexPath {
            return 2
        }
        return payObject.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDateCell") as! SelectDateTableViewCell
        let whatAreDo = ["Edit","Delete"]
        if payObject.first is IndexPath {
            
            let object = whatAreDo[indexPath.row]
            cell.set(object: object)
            
            return cell
        }
        
       
        let object = payObject[indexPath.row]
        if payObject != nil {
            cell.set(object: object)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if payObject.first is IndexPath {
            if indexPath.row == 0 {
                let dict = ["Edit":payObject.first as! IndexPath]
                closeSelectDateDelegate.closeTableView(object: dict)
                dismiss(animated: true, completion: nil)
                return
            }else{
                let dict = ["Delete":payObject.first as! IndexPath]
                closeSelectDateDelegate.closeTableView(object: dict)
                
                dismiss(animated: true, completion: nil)
                return
            }
        }
        let object = payObject[indexPath.row]
        closeSelectDateDelegate.closeTableView(object: object)
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


    

