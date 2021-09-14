//
//  InstallMenuTableView.swift
//  
//
//  Created by Артур on 14.09.21.
//

import UIKit

class InstallMenuTableView {
    
    
    let tbFrame = tableViewFrame()
    var tableView: MenuTableView!
    var owner: UIViewController!
    var account: MonetaryAccount?
    var menuIsActive = false
    init(owner: UIViewController) {
        self.owner = owner
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView = MenuTableView(frame: .zero, style: .plain)
        let y = owner.view.bounds.height - tbFrame.tableViewHeight - tbFrame.bottomIndent
        tableView.frame = CGRect(x: tbFrame.sideIndent, y: y, width: owner.view.bounds.width - tbFrame.sideIndent * 2, height: tbFrame.tableViewHeight)
        
    }
  
    private func animateShow() {
        let startYpoint = owner.view.bounds.height + tbFrame.tableViewHeight + tbFrame.bottomIndent
        let endYpoint = owner.view.bounds.height - tbFrame.tableViewHeight - tbFrame.bottomIndent
        tableView.frame.origin.y = startYpoint
        owner.view.addSubview(tableView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .allowUserInteraction) {
            self.tableView.frame.origin.y = endYpoint
        }
    }
    func hideMenu() {
        menuIsActive = false
        owner.view.addSubview(tableView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .allowUserInteraction) {
            self.tableView.frame.origin.y += 400
        }
        
        
    }
    func showMenu(account: MonetaryAccount?) {
        guard let account = account else {return}
        tableView.account = account
        animateShow()
        menuIsActive = true
        
    }
    
    class tableViewFrame {
        let cellHeight: CGFloat = 60
        let tableViewHeight:CGFloat = 60 * 3
        let bottomIndent: CGFloat = 22
        let sideIndent: CGFloat = 26
        
    }
}
