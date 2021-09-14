//
//  MenuTableView.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class MenuTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
   
    let colors = AppColors()
    var account: MonetaryAccount?
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        colors.loadColors()
        setupTableView()
        visualSettings()
    }
   
    func getMenuCells()-> [MenuCell] {
        
        let currencyImage = UIImage(named: account?.currencyISO ?? " ")
        let objects: [MenuCell] =  [
            MenuCell(menuType: .changeCurrency, menuImage: currencyImage!),
            MenuCell(menuType: .makeMain, menuImage: UIImage(named: "makeMainAccount")!),
            MenuCell(menuType: .delete, menuImage: UIImage(named: "deleteAccount")!) ]
        
        return objects
    }
    
    func visualSettings() {
        self.layer.cornerRadius = 14
        self.backgroundColor = colors.secondaryBackgroundColor
        self.layer.setMiddleShadow(color:colors.shadowColor )
        self.layer.masksToBounds = false
    }
    
    func setupTableView() {
        self.delegate = self
        self.dataSource = self
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
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let object = getMenuCells()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        cell.set(object: object)
        if indexPath.row == getMenuCells().count - 1 {
            cell.lineView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
