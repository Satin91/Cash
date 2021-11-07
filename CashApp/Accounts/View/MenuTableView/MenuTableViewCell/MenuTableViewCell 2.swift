//
//  MenuTableViewCell.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit



class MenuTableViewCell: CellWithCustomSelect  {
//let colors = AppColors()
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
    func switchMenuActions(newValue: MenuActions?) {
        guard let newValue = newValue else { return }
        switch newValue {
        case .makeMain:
            self.menuImage.image = UIImage(named: "makeMainAccount")
            self.menuImage.setImageColor(color: colors.titleTextColor)
            self.menuLabel.text = NSLocalizedString("account_edit_menu_assign_the_main", comment: "")
        case .delete:
            self.menuImage.image = UIImage(named: "deleteAccount")
            self.menuImage.setImageColor(color: colors.titleTextColor)
            self.menuLabel.text = NSLocalizedString("account_edit_menu_delete", comment: "")
        }
    }
    
    var menuAction: MenuActions? {
        willSet {
            self.switchMenuActions(newValue: newValue!)
        }
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
//    func cellAnimate() {
//        UIView.animate(withDuration: 0.15) {
//            self.contentView.backgroundColor = self.colors.contrastColor1
//        }completion: { _ in
//            UIView.animate(withDuration: 0.15) {
//                self.contentView.backgroundColor = self.colors.secondaryBackgroundColor
//            }
//        }
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if self.isSelected == true {
//            cellAnimate()
//        }
        
        // Configure the view for the selected state
    }
}


extension UITableViewCell {
    
}

