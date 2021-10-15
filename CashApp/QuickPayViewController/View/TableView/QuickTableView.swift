//
//  QuickTableView.swift
//  CashApp
//
//  Created by Артур on 18.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class QuickTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.backgroundColor = .clear
//        self.clipsToBounds = false
//        self.layer.masksToBounds = false
//        self.layer.masksToBounds = false
     //   self.clipsToBounds = false
        let nibName = UINib(nibName: "QuickTableViewCell", bundle: nil)
        self.register(nibName, forCellReuseIdentifier: "QuickTableViewCell")
        
        
        self.register(WithoutAccountTableViewCell.self, forCellReuseIdentifier: "WithoutAccountCell")
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
