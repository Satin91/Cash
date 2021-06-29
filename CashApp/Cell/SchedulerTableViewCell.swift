//
//  SchedulerTableViewCell.swift
//  CashApp
//
//  Created by Артур on 26.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SchedulerTableViewCell: UITableViewCell {
    
    //Labels
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var scheduleImage: UIImageView!
    @IBOutlet var nextPayLabelText: UILabel!
    @IBOutlet var nextPayDate: UILabel!
    
    @IBOutlet var sumLabelText: UILabel!
    @IBOutlet var sumLabel: UILabel!
    
    @IBOutlet var remainingSumLabelText: UILabel!
    @IBOutlet var remainingSum: UILabel!
    
    static func nib() -> UINib {
        let nib = UINib(nibName: "SchedulerTableViewCell", bundle: nil)
        return nib
    }
    
    func set(object: MonetaryScheduler) {
        fillTheDataForLabels(object: object, pptObject: getPPTObject(object: object))
    }
    
    func fillTheDataForLabels(object: MonetaryScheduler, pptObject: PayPerTime?) {
        titleLabel.text = object.name
        scheduleImage.image = UIImage(named: object.image)
        
        switch object.stringScheduleType {
        case .goal:
            
            nextPayLabelText.isHidden = true
            nextPayDate.isHidden = true
            sumLabelText.text = "Требуется"
            sumLabel.text = object.target.currencyFormatter(ISO: object.currencyISO)
            remainingSumLabelText.text = "Осталось"
            remainingSum.text = (object.target - object.available).currencyFormatter(ISO: object.currencyISO)
        case .oneTime:
            
            sumLabelText.text = "Cумма"
            sumLabel.text = (object.target - object.available).currencyFormatter(ISO: object.currencyISO)
            nextPayLabelText.text = "Дата"
            nextPayDate.text = dateToString(date: object.date!)
            remainingSumLabelText.isHidden = true
            remainingSum.isHidden = true
        case .multiply:
            
            guard let pptobject = pptObject else {return}
            sumLabelText.text = "Сумма"
            sumLabel.text = pptobject.target.currencyFormatter(ISO: object.currencyISO)
            nextPayLabelText.text = "Дата"
            nextPayDate.text = dateToString(date: pptobject.date)
            remainingSumLabelText.text = "Осталось"
            remainingSum.text = (object.target - object.available).currencyFormatter(ISO: object.currencyISO)
        case .regular:
            
            guard let pptobject = pptObject else {return}
            sumLabelText.text = "Сумма"
            sumLabel.text = pptobject.target.currencyFormatter(ISO: object.currencyISO)
            nextPayLabelText.text = "Дата"
            nextPayDate.text = dateToString(date: pptobject.date)
            remainingSumLabelText.isHidden = true
            remainingSum.isHidden = true
        }
        
    }
    func getPPTObject(object: MonetaryScheduler)-> PayPerTime? {
        let pptObject: PayPerTime? = {
            var pptObjects = [PayPerTime]()
            for i in payPerTimeObjects {
                if i.scheduleID == object.scheduleID{
                    pptObjects.append(i)
                }
            }
            guard pptObjects.first != nil else {return nil}
            return pptObjects.first!
        }()
        return pptObject
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
