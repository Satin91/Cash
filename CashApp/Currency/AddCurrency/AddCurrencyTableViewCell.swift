//
//  AddCurrencyTableViewCell.swift
//  CashApp
//
//  Created by Артур on 8.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddCurrencyTableViewCell: UITableViewCell {

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var currencyImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func visualSettings() {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.cornerRadius = 20
        self.contentView.backgroundColor = ThemeManager2.currentTheme().secondaryBackgroundColor
        self.backgroundColor = ThemeManager2.currentTheme().backgroundColor
        self.contentView.layer.setSmallShadow(color: ThemeManager2.currentTheme().shadowColor)
        self.descriptionLabel.textColor = ThemeManager2.currentTheme().titleTextColor
        self.descriptionLabel.font = .systemFont(ofSize: 19, weight: .regular)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds.inset(by: UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26))
    }
    func set(currencyObject: CurrencyObject) {
        visualSettings()
        currencyImage.image = UIImage(named: currencyObject.ISO)
        descriptionLabel.text = CurrencyList.CurrencyName(rawValue: currencyObject.ISO)?.getRaw
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
