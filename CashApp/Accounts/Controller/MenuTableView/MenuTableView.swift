//
//  MenuTableView.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class MenuTableView: UITableView{
   
    let colors = AppColors()
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        colors.loadColors()
        setupTableView()
        visualSettings()
    }
//    
//    func getMenuCells()-> [MenuCell]? {
//        
//        let objects: [MenuCell] =  [
//            MenuCell(menuType: .changeCurrency, account: account),
//            MenuCell(menuType: .makeMain, account: account),
//            MenuCell(menuType: .delete, account: account) ]
//        
//        return objects
//    }
    
    func visualSettings() {
        self.layer.cornerRadius = 14
        self.backgroundColor = colors.secondaryBackgroundColor
        self.layer.setMiddleShadow(color:colors.shadowColor )
        self.layer.masksToBounds = false
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "menuCell")
        self.separatorStyle = .none
        self.tableFooterView = UIView()
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    deinit {
        print("Deinit TableVIew")

    }

}
