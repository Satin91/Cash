//
//  LoadMenu.swift
//  CashApp
//
//  Created by Артур on 16.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension MenuTableView: UITableViewDelegate, UITableViewDataSource {
   

    
    func setupMenu(){
        let y = controller.view.bounds.height + 22
        let frameTableView = CGRect (x: 22, y: y, width: controller.view.bounds.width - 22 * 2, height: cellHeight * cellCount) // 80 - высота ячейки
        self.frame = frameTableView
    }
    
    func showMenuTableView() {
        //self.reloadData()
        self.controller.view.insertSubview(self, at: 10)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: .curveEaseInOut) {  [weak self] in
                guard let self = self else { return }
            self.frame.origin.y = self.controller.view.bounds.height - (self.cellHeight * self.cellCount) - 22 
        }
    }
    func hideMenuTableView() {
        UIView.animate(withDuration: Double(cellCount) / 10 * 2) {[weak self] in
            guard let self = self else { return }
            self.frame.origin.y = self.controller.view.bounds.height + 22
        }completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(cellCount)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        //guard account != nil else {return cell}
        cell.selectionStyle = .none
        if cellCount > 1 {
            switch indexPath.row {
            case 0:
                cell.menuAction = .makeMain
                cell.lineView.isHidden = false
                return cell
            case 1:
                cell.menuAction = .delete
                cell.lineView.isHidden = true
                return cell
            default:
                break
            }
            return cell
        }else{
            cell.menuAction = .delete
            cell.lineView.isHidden = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        self.sendAction(menuAction: cell.menuAction!)
    }
}
//}


