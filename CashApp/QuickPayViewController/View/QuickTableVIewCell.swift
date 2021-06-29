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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(object: MonetaryAccount){
        
        sumLabel.text = CurrencyName(rawValue: object.currencyISO)?.getRaw
        headerLabel.text = object.name
        
        //sumLabel.text = String(object.currencyISO)
    }

}
