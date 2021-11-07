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
let colors = AppColors()
    //Протокол который отправляет назад выбранные данные
    var closeSelectDateDelegate: ClosePopUpTableViewProtocol!
    var payObject: [Any]!
    let cellHeight: CGFloat = 60
    func showPopupMenu() {
        self.view.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.loadColors()
        self.view.backgroundColor = .clear
        navigationItem.title = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableViewSettings()
    }

////        UIView.animate(withDuration: 4) {
////            self.preferredContentSize = CGSize(width: 140, height: 140)
////        }
//    }

    func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        let xibCell = UINib(nibName: "PopTableViewCell", bundle: nil)
        tableView.register(xibCell, forCellReuseIdentifier: "PopTableViewCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = colors.secondaryBackgroundColor
        tableView.layer.setMiddleShadow(color: colors.shadowColor)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if payObject.first is IndexPath {
//            return 2
//        }
        return payObject.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopTableViewCell") as! PopTableViewCell
        let object = payObject[indexPath.row]
        if payObject != nil {
            cell.set(object: object)
            if indexPath.row == payObject.count - 1{
                cell.lineView.isHidden = true
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let object = payObject[indexPath.row]
        closeSelectDateDelegate.closeTableView(object: object)
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}


    

