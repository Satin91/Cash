//
//  SchedulerTableViewCell.swift
//  CashApp
//
//  Created by Артур on 26.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import SwipeCellKit
import Themer
protocol SendScheduleObjectToEdit {
    func sendObject(object: MonetaryScheduler)
}




class SchedulerTableViewCell: SwipeTableViewCell {
    
    let colors = AppColors()
    var sendSchedulerDelegate: SendScheduleObjectToEdit!
    
    @IBOutlet var roundedBackground: UIView!
    @IBOutlet var titleLabel: TitleLabel!
    
    @IBOutlet var scheduleImage: UIImageView!
    @IBOutlet var nextPayLabelText: SubTitleLabel!
    @IBOutlet var nextPayDate: TitleLabel!
    
    @IBOutlet var sumLabelText: SubTitleLabel!
    @IBOutlet var sumLabel: TitleLabel!
    
    @IBOutlet var remainingSumLabelText: SubTitleLabel!
    @IBOutlet var remainingSum: TitleLabel!
    @IBOutlet var editButtonOutlet: UIButton!
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        guard let object = self.object else {return}
        sendSchedulerDelegate.sendObject(object: object)
    }
    static func nib() -> UINib {
        let nib = UINib(nibName: "SchedulerTableViewCell", bundle: nil)
        return nib
    }
    weak var object: MonetaryScheduler!
    var lockView: LockView!

    func lock(_ isLock: Bool) {
        lockView.isHidden = !isLock
    }
    func set(object: MonetaryScheduler) {
        
        fillTheDataForLabels(object: object, pptObject: getPPTObject(object: object))
        Themer.shared.register(target: self, action: SchedulerTableViewCell.theme(_:))
    }

    func fillTheDataForLabels(object: MonetaryScheduler, pptObject: PayPerTime?) {
        titleLabel.text = object.name
        
        scheduleImage.image = UIImage().myImageList(systemName: object.image)
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
            nextPayDate.text = dateToString(date: object.date)
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
        titleLabel.font = .systemFont(ofSize: 19, weight: .medium)
        
        nextPayLabelText.font = .systemFont(ofSize: 14, weight: .medium)
        nextPayDate.font = .systemFont(ofSize: 14, weight: .regular)
        
        sumLabelText.font = .systemFont(ofSize: 14, weight: .medium)
        sumLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        remainingSumLabelText.font = .systemFont(ofSize: 14, weight: .medium)
        remainingSum.font = .systemFont(ofSize: 14, weight: .regular)
        
        //background
        roundedBackground.layer.cornerRadius = 25
       
        
        self.backgroundColor = .clear
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.lockView = LockView(frame: .zero)
        self.lockView.addLock(to: roundedBackground, lockSize: .plan)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        visualSettings()
        
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        self.roundedBackground.layer.masksToBounds = false
        self.lockView = LockView(frame: .zero)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension SchedulerTableViewCell{
     func theme(_ theme: MyTheme) {
        roundedBackground.backgroundColor = theme.settings.secondaryBackgroundColor
        roundedBackground.layer.setSmallShadow(color: theme.settings.shadowColor)
        scheduleImage.changePngColorTo(color: theme.settings.titleTextColor) 
    }
}
