//
//  QuickTableVIewCell.swift
//  CashApp
//
//  Created by Артур on 19.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class QuickTableVIewCell: CellWithCustomSelect {
    
    @IBOutlet var headerLabel: TitleLabel!
    @IBOutlet var sumLabel: SubTitleLabel!
    @IBOutlet var userImage: UIImageView!
   // let colors = AppColors()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     //   colors.loadColors()
        // Initialization code
        colors.loadColors()
        visualSettings()
    }
    
    func labels() {
        headerLabel.font = .systemFont(ofSize: 22, weight: .regular)
        sumLabel.font = .systemFont(ofSize: 17, weight: .regular)
    }
    
    func visualSettings(){
        labels()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = colors.secondaryBackgroundColor
        self.contentView.sendSubviewToBack(userImage)
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.setMiddleShadow(color: colors.borderColor)
        self.contentView.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.headerLabel.textColor = colors.titleTextColor
        self.sumLabel.textColor = colors.subtitleTextColor
        self.userImage.layer.cornerRadius = 8
        self.userImage.clipsToBounds = true
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
        
        sumLabel.text = object.balance.currencyFormatter(ISO: object.currencyISO)
        headerLabel.text = object.name
    }

}
