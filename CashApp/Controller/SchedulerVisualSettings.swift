//
//  VisualSettings.swift
//  CashApp
//
//  Created by Артур on 10.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

extension AddScheduleViewController {
  
    func theme(_ theme: MyTheme){
        self.titleTextColor = theme.settings.titleTextColor
        self.borderColor = theme.settings.borderColor
        incomeVectorButtonOutlet.backgroundColor = theme.settings.borderColor
        expenceVectorButtonOutlet.backgroundColor = theme.settings.titleTextColor
        selectImageButtonOutlet.backgroundColor = theme.settings.secondaryBackgroundColor
        
        setColors(backgroundColor: theme.settings.backgroundColor,
                       titleColor: theme.settings.titleTextColor,
                       borderColor: theme.settings.borderColor,
                       subtitleColor: theme.settings.subtitleTextColor,
                       shadowColor: theme.settings.shadowColor)
        nameTextField.borderedTheme(fillColor: theme.settings.secondaryBackgroundColor, shadowColor: theme.settings.shadowColor)
        totalSumTextField.borderedTheme(fillColor: theme.settings.secondaryBackgroundColor, shadowColor: theme.settings.shadowColor)
        sumPerTimeTextField.borderedTheme(fillColor: theme.settings.secondaryBackgroundColor, shadowColor: theme.settings.shadowColor)
    }
    
    func setColors(backgroundColor: UIColor,titleColor: UIColor,borderColor:UIColor,subtitleColor: UIColor,shadowColor: UIColor) {
        self.view.backgroundColor = backgroundColor
        self.headingTextLabel.textColor = titleColor
        self.descriptionTextLabel.textColor = subtitleColor
        incomeVectorButtonOutlet.setTitleColor(borderColor, for: .normal)
        expenceVectorButtonOutlet.setTitleColor(borderColor, for: .normal)
        selectImageButtonOutlet.setImage(UIImage(named: selectedImageName), for: .normal)
        selectImageButtonOutlet.setImageTintColor(titleColor, imageName: selectedImageName)
        selectImageButtonOutlet.layer.setMiddleShadow(color: shadowColor)
        scrollView.backgroundColor = .clear
        setupButtonsAndFields(subTitleColor: subtitleColor)
        
    }
    func visualSettings() {
        self.headingTextLabel.numberOfLines = 2
        self.headingTextLabel.minimumScaleFactor = 0.5
        self.headingTextLabel.font = .systemFont(ofSize: 34, weight: .medium)
        self.descriptionTextLabel.font = .systemFont(ofSize: 17, weight: .light)
        descriptionTextLabel.numberOfLines = 0
        incomeVectorButtonOutlet.layer.cornerRadius = 10
        expenceVectorButtonOutlet.layer.cornerRadius = 10
        let isEditingButtonTitle = isEditingScheduler ? NSLocalizedString("save_button", comment: "") : NSLocalizedString("create_button", comment: "")
        selectDateButtonOutlet.mainButtonTheme("date_button")
        okButtonOutlet.mainButtonTheme(isEditingButtonTitle)
        selectImageButtonOutlet.layer.cornerRadius = 25
        scrollView.backgroundColor = .clear
    }
    func setupButtonsAndFields(subTitleColor: UIColor) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: subTitleColor ])
        
        let sumPerTimeText = newScheduleObject.stringScheduleType == .goal ? NSLocalizedString("available_sum", comment: "") : NSLocalizedString("sum_per_time_text_field", comment: "")
        totalSumTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("total_sum_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: subTitleColor])
        sumPerTimeTextField.attributedPlaceholder = NSAttributedString(string: sumPerTimeText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: subTitleColor])
        
//        nameTextField.changeVisualDesigh()
//        totalSumTextField.changeVisualDesigh()
//        sumPerTimeTextField.changeVisualDesigh()
        let title = isEditingScheduler ? newScheduleObject.currencyISO : mainCurrency!.ISO
        rightViewTextFieldButtonFor(title: title)
    }
}