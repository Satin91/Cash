//
//  CurrencyTableViewCell.swift
//  CashApp
//
//  Created by Артур on 5.05.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet var currencyFlag: UIImageView!
    @IBOutlet var currencyISO: UILabel!
    @IBOutlet var currencyDesctiption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(object: CurrencyObject) {
        currencyISO.text = object.ISO
        guard let image = UIImage(named: object.ISO) else {return}
        currencyFlag.image = image
        
    }
    
}
