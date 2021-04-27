//
//  SelectDateTableViewCell.swift
//  CashApp
//
//  Created by Артур on 27.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SelectDateTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func set(payPerTime: PayPerTime) {
        nameLabel.text = payPerTime.scheduleName
        let totalSum = payPerTime.sumPerTime - payPerTime.available
        sumLabel.text = String(totalSum.currencyFR)
    }
    
}
