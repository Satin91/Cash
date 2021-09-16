//
//  MenuTableViewCell.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

struct MenuCell {
    var menuType: MenuCellType
    var account: MonetaryAccount
}
enum MenuCellType {
    case changeCurrency
    case makeMain
    case delete
}


class MenuTableViewCell: UITableViewCell {
let colors = AppColors()
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var menuLabel: UILabel!
    var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        colors.loadColors()
        setupLabel()
        setupContentView()
    }
    func setupContentView() {
      //  self.contentView.frame = self.bounds.insetBy(dx: 26, dy: 0)
        
        lineView = SeparatorView(cell: self).createLineViewWithConstraints()
        lineView.backgroundColor = colors.separatorColor
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    func setupLabel(){
        menuLabel.textColor = colors.titleTextColor
        menuLabel.font = .systemFont(ofSize: 17, weight: .medium)
        menuLabel.text = "This is menu"
        menuImage.image = UIImage(named: "deleteAccount")
    }
    

    func set(object: MenuCell) {
        
        switch object.menuType {
        case .changeCurrency:
            self.menuLabel.text = "Change currency"
            self.menuImage.contentMode = .scaleAspectFit
            self.menuImage.image = UIImage(named: object.account.currencyISO)!.withAlignmentRectInsets(UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2) )
        case .makeMain:
            self.menuImage.image = UIImage(named: "makeMainAccount")
            self.menuLabel.text = "Make main"
            self.menuImage.setImageColor(color: colors.titleTextColor)
        case .delete:
            self.menuImage.image =  UIImage(named: "deleteAccount")
            self.menuLabel.text = "Delete"
            self.menuLabel.font = .systemFont(ofSize: 17, weight: .medium)
            self.menuImage.setImageColor(color: colors.titleTextColor)
            self.menuLabel.textColor = colors.redColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
