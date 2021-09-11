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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        self.backgroundColor = .clear
        self.addSubview(tableView)
        initConstraints(view: tableView, to: self)
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        tableView.layer.masksToBounds = false
        tableView.clipsToBounds = false
        let nibName = UINib(nibName: "QuickTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "QuickTableViewCell")
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WithoutAccountCell")
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
