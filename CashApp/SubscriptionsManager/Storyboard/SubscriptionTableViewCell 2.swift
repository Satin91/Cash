//
//  SubscriptionTableViewCell.swift
//  CashApp
//
//  Created by Артур on 21.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

    
    let colors = AppColors()
    override func awakeFromNib() {
        super.awakeFromNib()
        colors.loadColors()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func set() {
        
    }
}
