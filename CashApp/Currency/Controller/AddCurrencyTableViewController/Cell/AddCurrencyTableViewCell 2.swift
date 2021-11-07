//
//  AddCurrencyTableViewCell.swift
//  CashApp
//
//  Created by Артур on 8.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddCurrencyTableViewCell: UITableViewCell {
  
    let colors = AppColors()
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var currencyImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colors.loadColors()
        setupImage()
    }
    func setupImage(){
        self.currencyImage.layer.setCircleShadow(color: colors.shadowColor.withAlphaComponent(0.2))
        self.currencyImage.layer.masksToBounds = false
    }
    func visualSettings() {
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.cornerRadius = 14
        self.descriptionLabel.font = .systemFont(ofSize: 19, weight: .regular)
        self.descriptionLabel.minimumScaleFactor = 0.6
        self.descriptionLabel.adjustsFontSizeToFitWidth = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds.inset(by: UIEdgeInsets(top: 10, left: 22, bottom: 10, right: 22))
      
    }
    func set(currencyObject: CurrencyObject) {
        visualSettings()
        
        currencyImage.image = UIImage(named: currencyObject.ISO)
        descriptionLabel.text = CurrencyList.CurrencyName(rawValue: currencyObject.ISO)?.getRaw
        self.setCellColors()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
