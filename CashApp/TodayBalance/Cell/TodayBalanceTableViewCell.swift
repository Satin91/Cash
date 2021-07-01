//
//  TodayBalanceTableViewCell.swift
//  CashApp
//
//  Created by Артур on 1.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class TodayBalanceTableViewCell: UITableViewCell {
    let theme = ThemeManager.currentTheme()
    @IBOutlet var monetaryImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = ThemeManager.currentTheme().separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   static let identifier = "TodayBalanceTableViewCell"
   static func nib() -> UINib {
        let nib = UINib(nibName: "TodayBalanceTableViewCell", bundle: nil)
        return nib
        
    }
    func visualSettings() {
        titleLabel.textColor = theme.titleTextColor
        titleLabel.font = .systemFont(ofSize: 19, weight: .regular)
        subTitleLabel.textColor = theme.subtitleTextColor
        subTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        monetaryImage.contentMode = .scaleAspectFill
        monetaryImage.layer.cornerRadius = 10
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    func setUnderline(isLast: Bool){
        
    }
    func setConstraintsForUnderLine(){
        self.contentView.addSubview(lineView)
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func set(object: Any) {
        if object is MonetaryScheduler {
            let object = object as! MonetaryScheduler
            titleLabel.text = object.name
            subTitleLabel.text = object.currencyISO
            monetaryImage.image = UIImage(named: object.image)
        }else if object is PayPerTime{
            let object = object as! PayPerTime
            titleLabel.text = object.scheduleName
            subTitleLabel.text = object.currencyISO
            for i in EnumeratedSchedulers(object: schedulerGroup) {
                if i.scheduleID == object.scheduleID {
                    monetaryImage.image = UIImage(named: i.image)
                }
            }
        }else if object is MonetaryAccount {
            let object = object as! MonetaryAccount
            titleLabel.text = object.name
            subTitleLabel.text = object.balance.currencyFormatter(ISO: object.currencyISO)
            monetaryImage.image = UIImage(named: object.imageForAccount)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        visualSettings()
        setConstraintsForUnderLine()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
