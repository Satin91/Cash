//
//  SubscriptionCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 6.11.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SubscriptionCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let ID = "SubscriptionCell"
    let colors = AppColors()
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        colors.loadColors()
        
    }
    func set(description: SubscriptionCellModel){
  
        titleLabel.text = description.titleLabelName
        descriptionLabel.text = description.descriptionLabel
        titleImage.image = description.image
        titleImage.tintColor = colors.redColor
        titleImage.setImageColor(color: colors.redColor)
        setLabelColors(titleLabel, color: colors.titleTextColor)
        setLabelColors(descriptionLabel, color: colors.subtitleTextColor)
    }

//    func setContentView() {
//        self.contentView.backgroundColor = colors.secondaryBackgroundColor
//        self.contentView.layer.cornerRadius = 25
//        self.contentView.layer.cornerCurve  = .continuous
//    }
  
    func setLabelColors(_ label: UILabel, color: UIColor) {
        label.textColor = color
    }
    

}
