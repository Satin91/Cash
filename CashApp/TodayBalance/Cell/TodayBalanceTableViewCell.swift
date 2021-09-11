//
//  TodayBalanceTableViewCell.swift
//  CashApp
//
//  Created by Артур on 1.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class TodayBalanceTableViewCell: UITableViewCell {
    let colors = AppColors()

    
    @IBOutlet var monetaryImage: UIImageView!
    @IBOutlet var titleLabel: TitleLabel!
    @IBOutlet var subTitleLabel: SubTitleLabel!
    var swtch: AIFlatSwitch!
    var separatorView: UIView!
    var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = ThemeManager2.currentTheme().separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   static let identifier = "TodayBalanceTableViewCell"
   static func nib() -> UINib {
        let nib = UINib(nibName: "TodayBalanceTableViewCell", bundle: nil)
        return nib
        
    }
    func setConstraintsForUnderLine(){
        separatorView = SeparatorView(cell: self).createLineViewWithConstraints()
        separatorView.backgroundColor = colors.separatorColor
    }
    
    func visualSettings() {
    
        
        titleLabel.font = .systemFont(ofSize: 19, weight: .regular)
        
        subTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        monetaryImage.contentMode = .scaleAspectFill
        monetaryImage.layer.cornerRadius = 10
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
       // insertSwitchInCell()
    }
    
    
    
    var switchTogle: Bool = false
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
 
    func set(object: Any) {
        if object is SchedulersForTableView {
            let object = object as! SchedulersForTableView
            titleLabel.text = object.scheduler.name
            let text = object.todaySum.currencyFormatter(ISO: object.scheduler.currencyISO)
            subTitleLabel.text = object.scheduler.vector ? "+" + text : "-" + text
            monetaryImage.image = UIImage(named: object.scheduler.image)
            monetaryImage.changePngColorTo(color: colors.titleTextColor)
        }else if object is PayPerTime{
            let object = object as! PayPerTime
            titleLabel.text = object.scheduleName
            subTitleLabel.text = object.currencyISO
            
            for i in EnumeratedSchedulers(object: schedulerGroup) {
                if i.scheduleID == object.scheduleID {
                    monetaryImage.image = UIImage(named: i.image)
                    monetaryImage.changePngColorTo(color: colors.titleTextColor)
                }
            }
        }else if object is MonetaryAccount {
            let object = object as! MonetaryAccount
            titleLabel.text = object.name
            subTitleLabel.text = object.balance.currencyFormatter(ISO: object.currencyISO)
            monetaryImage.image = UIImage(named: object.imageForAccount)
        }
        
    }
    
    func togleSwitch() {
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        colors.loadColors()
        visualSettings()
        
        setConstraintsForUnderLine()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
}
