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
        //tableView.layer.cornerRadius = 18
        
        //translatesAutoresizingMaskIntoConstraints можно увидеть в настройках онстрейнтов в сториборде, у тебя в данный момент это стоит на трех главных кнопках
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //применили констрейнты для собственной вьюшки
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = whiteThemeBackground
        
        
        
        appendInReturnObjects()
        let nibName = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "DropDownTableViewCellIdentifier")

        let nibName2 = UINib(nibName: "CellForDropDown", bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: "CellForDropDownIdentifier")
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func appendInReturnObjects() {
        returnObjects.insert(dontUseAccount, at: 0)
    }
    var returnObjects = returnArrayOutOfObject(object: accountsObjects)
    let dontUseAccount = MonetaryEntity(name: "Don't use accounts", sum: 0, userDescription: nil, date: nil, image: nil, accountType: nil, userPerent: 0)
    /// TableViewSettings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  returnObjects.count //EnumeratedSequence(array: accountsObjects).count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDropDownIdentifier", for: indexPath) as! TableViewCell
            cell.DropDownCellTwoLabel.text = "Don't use account"
            cell.backgroundColor = whiteThemeBackground
            cell.DropDownCellTwoLabel.textColor = whiteThemeMainText
            return cell
        }
        
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCellIdentifier", for: indexPath) as! TableViewCell
        //let object = EnumeratedSequence(array: accountsObjects)[indexPath.row]
        let object = returnObjects[indexPath.row]
           //let object = dontUseAccount
           cell.set(object: object)
           cell.descriptionLabel.text = "Balance"
           return cell

    }
//        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.DropDownTableViewCellIdentifier, for: indexPath) as! TableViewCell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object = returnObjects[indexPath.row]
        //let object = EnumeratedSequence(array: accountsObjects)[indexPath.row]
        self.dropDelegate.dropDownAccountNameAndIndexPath(string: object.name, indexPath: indexPath.row - 1) // Тут должно быть условие где должно соблюдаться нличие последнего или основного счета. Сейчас стоит - 1 index path для удобства в данный момент
        self.dropDelegate.dropDownAccountIdentifier(identifier: object.monetaryID)
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}


