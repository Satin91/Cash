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
    
    func set(object: Any){
        if object is MonetaryScheduler {
            let obj = object as! MonetaryScheduler
            setSchedule(scheduleObject: obj)
        }else if object is PayPerTime {
            let obj = object as! PayPerTime
            setPayPerTime(payPerTime: obj)
        }else if object is CurrencyObject {
            let obj = object as! CurrencyObject
            setCurrency(object: obj)
        }else if object is String {
            let obj = object as! String
            setAction(object: obj)
            
        }
    }
    func setAction(object: String) {
        nameLabel.text = object
        sumLabel.isHidden = true
    }
    
    func setCurrency(object: CurrencyObject) {
        nameLabel.text = object.ISO
        sumLabel.isHidden = true
    }
    
    func setSchedule(scheduleObject: MonetaryScheduler){
        nameLabel.text = scheduleObject.name
        let totalSum = scheduleObject.target - scheduleObject.available
        sumLabel.text = String(totalSum.currencyFormatter(ISO: scheduleObject.currencyISO))
        
    }
    func setPayPerTime(payPerTime: PayPerTime) {
        nameLabel.text = payPerTime.scheduleName
        var currency = mainCurrency?.ISO
        for i in EnumeratedSchedulers(object: schedulerGroup) {
            if i.scheduleID == payPerTime.scheduleID{
                currency = i.currencyISO
            }
        }
        let totalSum = payPerTime.target
        sumLabel.text = String(totalSum.currencyFormatter(ISO: currency))
    }
    
}
