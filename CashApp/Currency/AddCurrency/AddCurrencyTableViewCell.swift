//
//  AddCurrencyTableViewCell.swift
//  CashApp
//
//  Created by Артур on 8.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddCurrencyTableViewCell: UITableViewCell {

    @IBOutlet var isoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(currencyObject: CurrencyObject) {
        isoLabel.text = currencyObject.ISO
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
