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
    var neoView = NeoView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        neoView = NeoView(frame: frame)
        
        
        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = .gray
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.backgroundColor = .clear
        neoView.addSubview(tableView)
        
        self.addSubview(neoView)
        initConstraints(view: tableView, to: neoView)
        initConstraints(view: neoView, to: self)
        
        

        let nibName = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "QuickTableViewCell")

        let nibName2 = UINib(nibName: "FirstDropDownTableViewCell", bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: "FirstDropDownTableViewCellIdentifier")
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
