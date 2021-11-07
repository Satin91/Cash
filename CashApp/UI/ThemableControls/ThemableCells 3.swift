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
class CellWithCustomSelect: UITableViewCell {
    let colors = AppColors()
    func cellAnimate() {
        colors.loadColors()
        UIView.animate(withDuration: 0.02) {
            self.contentView.backgroundColor = self.colors.borderColor.withAlphaComponent(0.8)
        }completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.contentView.backgroundColor = self.colors.secondaryBackgroundColor
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected {
        cellAnimate()
        }
    }
}
