//
//  SelectDateTableViewCell.swift
//  CashApp
//
//  Created by Артур on 27.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class PopTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: TitleLabel!
    @IBOutlet var sumLabel: SubTitleLabel!
   
    let colors = AppColors()
    var lineView: UIView = {
        let view = UIView()
        
        return view
    }()
    @IBOutlet var popCellImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        visualSettings()
    }
    func visualSettings() {
        colors.loadColors()
        lineView.backgroundColor = colors.borderColor.withAlphaComponent(0.6)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.popCellImage.layer.setCircleShadow(color: colors.shadowColor.withAlphaComponent(0.2))
        self.popCellImage.layer.masksToBounds = false
    }
    
    func createConstraints() {
        self.contentView.addSubview(lineView)
        lineView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: self.contentView.bounds.width / 8).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -self.contentView.bounds.width / 8).isActive = true
        lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -1.5).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
    }
    
 
    override func layoutSubviews() {
        super.layoutSubviews()
        createConstraints()
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
        }
    }
  
    
    
    
    func setCurrency(object: CurrencyObject) {
        nameLabel.text = object.ISO
        sumLabel.isHidden = true
        popCellImage.image = UIImage().myImageList(systemName: object.ISO)
    }
    
    func setSchedule(scheduleObject: MonetaryScheduler){
        nameLabel.text = scheduleObject.name
        nameLabel.textAlignment = .left
        sumLabel.textAlignment = .left
        let totalSum = scheduleObject.target - scheduleObject.available
        sumLabel.text = String(totalSum.currencyFormatter(ISO: scheduleObject.currencyISO))
        popCellImage.image = UIImage().myImageList(systemName: scheduleObject.image)
        popCellImage.setImageColor(color: colors.titleTextColor)
    }
    func setPayPerTime(payPerTime: PayPerTime) {
        nameLabel.text = payPerTime.scheduleName
        var currency = mainCurrency?.ISO
        for i in EnumeratedSchedulers(object: schedulerGroup) {
            if i.scheduleID == payPerTime.scheduleID{
                currency = i.currencyISO
                popCellImage.image = UIImage().myImageList(systemName: i.image)
                popCellImage.setImageColor(color: colors.titleTextColor)
            }
        }
        let totalSum = payPerTime.target
        sumLabel.text = String(totalSum.currencyFormatter(ISO: currency))
    }
    
}
