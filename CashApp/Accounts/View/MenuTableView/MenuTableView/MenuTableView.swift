//
//  MenuTableView.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

enum MenuActions {
    case makeMain
    case delete
}
protocol MenuTableViewTappedDelegate: AnyObject {
    func tappedForRow(action: MenuActions)
}
class MenuTableView: UITableView{
   
    let colors = AppColors()
    let cellHeight: CGFloat = 80
    weak var tappedDelegate: MenuTableViewTappedDelegate!
    weak var controller: UIViewController!
    var alertView: AlertViewController!
    func receiveAccount(isMain: Bool) {
        guard accountsObjects.count > 1 else { // Обнуляет фрейм, когда только 1 счет
            self.frame = .zero
            return }
        cellCount = isMain == true ? 1 : 2
        self.setupMenu()
        self.reloadData()
    }
    
    var cellCount = CGFloat()
    init(frame: CGRect, style: UITableView.Style, controller: UIViewController) {
        super.init(frame: frame, style: style)
        self.controller = controller as! AccountsViewController
        alertView = AlertViewController.loadFromNib()
        alertView.controller = controller
        colors.loadColors()
        setupTableView()
        visualSettings()
        self.delegate = self
        self.dataSource = self
        
    }
    
    func visualSettings() {
        self.layer.cornerRadius = 14
        self.backgroundColor = colors.secondaryBackgroundColor
        self.layer.setMiddleShadow(color:colors.shadowColor )
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "menuCell")
        self.separatorStyle = .none
        self.tableFooterView = UIView()
        self.isScrollEnabled = false
    }
    func sendAction(menuAction: MenuActions) {
        self.tappedDelegate.tappedForRow(action: menuAction)
        
        if menuAction == .makeMain {
            cellCount = 1
            self.performBatchUpdates {
                self.deleteRows(at: [IndexPath(row: 0, section: 0) ], with: .top)
                
                UIView.animate(withDuration: 0.3) {[weak self] in // 0.3 как оказалось дефолтная скорость изменения ячеек
                    guard let self = self else { return }
                    self.frame.size.height -= self.cellHeight
                    self.frame.origin.y += self.cellHeight
                }
     
            }
        }
    }
        
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


