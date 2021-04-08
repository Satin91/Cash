//
//  QuickTableView.swift
//  CashApp
//
//  Created by Артур on 18.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class QuickTableView: UIView {
    
    
   
    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = .gray
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.addSubview(tableView)
        initConstraints(view: tableView, to: self)
        
        

        let nibName = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "QuickTableViewCell")

        let nibName2 = UINib(nibName: "FirstDropDownTableViewCell", bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: "FirstDropDownTableViewCellIdentifier")
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
