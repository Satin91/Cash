//
//  SchedulerTableViewCell.swift
//  CashApp
//
//  Created by Артур on 26.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import SwipeCellKit
protocol SendScheduleObjectToEdit {
    func sendObject(object: MonetaryScheduler)
}
class SchedulerTableViewCell: SwipeTableViewCell {
    
    //Labels
    var sendSchedulerDelegate: SendScheduleObjectToEdit!
    
    @IBOutlet var roundedBackground: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var scheduleImage: UIImageView!
    @IBOutlet var nextPayLabelText: UILabel!
    @IBOutlet var nextPayDate: UILabel!
    
    @IBOutlet var sumLabelText: UILabel!
    @IBOutlet var sumLabel: UILabel!
    
    @IBOutlet var remainingSumLabelText: UILabel!
    @IBOutlet var remainingSum: UILabel!
    @IBOutlet var editButtonOutlet: UIButton!
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        guard let object = self.object else {return}
        sendSchedulerDelegate.sendObject(object: object)
        
    }
    static func nib() -> UINib {
        let nib = UINib(nibName: "SchedulerTableViewCell", bundle: nil)
        return nib
    }
    
    var object: MonetaryScheduler!
    
    func set(object: MonetaryScheduler) {
        fillTheDataForLabels(object: object, pptObject: getPPTObject(object: object))
    }
    
    func fillTheDataForLabels(object: MonetaryScheduler, pptObject: PayPerTime?) {
        titleLabel.text = object.name
        scheduleImage.image = UIImage(named: object.image)
        self.object = object
        switch object.stringScheduleType {
        case .goal:
            nextPayLabelText.isHidden = true
            nextPayDate.isHidden = true
            sumLabelText.isHidden = false
            sumLabel.isHidden = false
            remainingSum.isHidden = false
            remainingSumLabelText.isHidden = false
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
           // remainingSum.isHidden = false
            //remainingSumLabelText.isHidden = false
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
    
    func visualSettings(){
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = ThemeManager.currentTheme().titleTextColor
        
        nextPayLabelText.font = .systemFont(ofSize: 14, weight: .regular)
        nextPayLabelText.textColor = ThemeManager.currentTheme().subtitleTextColor
        nextPayDate.font = .systemFont(ofSize: 14, weight: .regular)
        nextPayDate.textColor = ThemeManager.currentTheme().titleTextColor
        
        sumLabelText.font = .systemFont(ofSize: 14, weight: .regular)
        sumLabel.font = .systemFont(ofSize: 14, weight: .regular)
        sumLabelText.textColor = ThemeManager.currentTheme().subtitleTextColor
        sumLabel.textColor = ThemeManager.currentTheme().titleTextColor
        
        remainingSumLabelText.font = .systemFont(ofSize: 14, weight: .regular)
        remainingSum.font = .systemFont(ofSize: 14, weight: .regular)
        remainingSumLabelText.textColor = ThemeManager.currentTheme().subtitleTextColor
        remainingSum.textColor = ThemeManager.currentTheme().titleTextColor
        
        //background
        roundedBackground.layer.cornerRadius = 25
        roundedBackground.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        self.backgroundColor = .clear
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        visualSettings()
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        self.roundedBackground.layer.masksToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
