//
//  ThemableCells.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//


import UIKit
import Themer

extension UITableViewCell {
     func setColors() {
        Themer.shared.register(target: self, action: UITableViewCell.setColors(_:))
    }
    func setColors(_ theme:MyTheme){
        self.backgroundColor = theme.settings.secondaryBackgroundColor
        self.textLabel?.textColor = theme.settings.titleTextColor
    }
}
