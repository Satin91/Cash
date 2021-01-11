//
//  DropDownTableView.swift
//  CashApp
//
//  Created by Артур on 27.11.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit



class DropDownTableView: UIView, UITableViewDataSource, UITableViewDelegate{
    
    var tableView = UITableView()
    
    var dropDelegate : DropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.layer.cornerRadius = 18
        
        //translatesAutoresizingMaskIntoConstraints можно увидеть в настройках онстрейнтов в сториборде, у тебя в данный момент это стоит на трех главных кнопках
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //применили констрейнты для собственной вьюшки
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
   
        tableView.backgroundColor = whiteThemeBackground

        let nibName = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "DropDownTableViewCellIdentifier")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    /// TableViewSettings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EnumeratedSequence(array: accountsObjects).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.DropDownTableViewCellIdentifier, for: indexPath) as! TableViewCell
        let object = EnumeratedSequence(array: accountsObjects)[indexPath.row]
        cell.set(object: object)
        cell.descriptionLabel.text = "Balance"
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //addVC.initDropDownTableView() // Не понимаю почему, но тут тоже надо инициализировать меню
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let opVC = storyboard.instantiateViewController(withIdentifier: "operationVC") as! OperationViewController
        //opVC.accountEntity = EnumeratedSequence(array: accountsObjects)[indexPath.row]
        let object = EnumeratedSequence(array: accountsObjects)[indexPath.row]
        self.dropDelegate.dropDownAccountName(string: object.name)
        self.dropDelegate.dropDownIndexPath(indexPath: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}


