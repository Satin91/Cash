//
//  MainTableViewCell.swift
//  CashApp
//
//  Created by Артур on 3.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet var monetaryImage: UIImageView!
    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var roundedBackground: UIView!
    
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedBackground.layer.cornerRadius = 12
        roundedBackground.backgroundColor = .systemGray6
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
    }
    
    func toSchedule(schedule: MonetaryScheduler) {
        primaryLabel.text = schedule.name
        guard let date = schedule.date else {return}
        secondaryLabel.text = dateToString(date: date)
        monetaryImage.image = UIImage(named: schedule.image)
        
    }
    
    func toHistory(history: AccountsHistory) {
        primaryLabel.text = history.name
        secondaryLabel.text = dateToString(date: history.date)
        sumLabel.text = history.sum.currencyFormatter(ISO: "BYN")
        monetaryImage.image = UIImage(named: history.image!)
    }
    
    func toCategory(category: MonetaryCategory) {
        primaryLabel.text = category.name
        secondaryLabel.text = "Balance"
        sumLabel.text = String(category.sum.currencyFormatter(ISO: category.currencyISO))
        monetaryImage.image = UIImage(named: category.image)
    }
    
    func set<A>(monetaryObject: A) {
        
        if monetaryObject is AccountsHistory {
            let object = monetaryObject as! AccountsHistory
            toHistory(history: object)
        }else if monetaryObject is MonetaryCategory {
            let object = monetaryObject as! MonetaryCategory
            toCategory(category: object)
        }else if monetaryObject is MonetaryScheduler {
            let object = monetaryObject as! MonetaryScheduler
            toSchedule(schedule: object)
        }
        
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
