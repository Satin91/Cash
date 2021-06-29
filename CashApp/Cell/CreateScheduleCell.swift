//
//  CreateScheduleCell.swift
//  CashApp
//
//  Created by Артур on 27.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CreateScheduleCell: UITableViewCell {

    @IBOutlet var createScheduleLabel: UILabel!
    
    static func nib() -> UINib {
        let nib = UINib(nibName: "CreateScheduleCell", bundle: nil)
        
        return nib
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        createScheduleLabel.text = "Create"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
