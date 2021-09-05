//
//  QuickTableVIewCell.swift
//  CashApp
//
//  Created by Артур on 19.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class QuickTableVIewCell: UITableViewCell {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
   
    
    
    
     
    @IBOutlet var userImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        visualSettings()
    }
    func visualSettings(){
        self.backgroundColor = .clear
        self.contentView.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        self.contentView.sendSubviewToBack(userImage)
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.setMiddleShadow(color: ThemeManager.currentTheme().borderColor)
        self.contentView.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.headerLabel.textColor = ThemeManager.currentTheme().titleTextColor
        self.sumLabel.textColor = ThemeManager.currentTheme().titleTextColor
        self.userImage.layer.cornerRadius = 6
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26))
        
    }
    
    func set(object: MonetaryAccount){
        userImage.image = UIImage(named: object.imageForAccount) ?? UIImage(systemName: "House")
        sumLabel.text = CurrencyList.CurrencyName(rawValue: object.currencyISO)?.getRaw
        headerLabel.text = object.name
    }

}
