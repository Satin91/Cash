//
//  VisualSettings.swift
//  CashApp
//
//  Created by Артур on 10.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
import Themer
extension AddScheduleViewController {
  
    // set the selected colors (after release change this shit to COLORS.LOADCOLORS)
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
    
    // Set colors and image for image button
    
    func setColors(backgroundColor: UIColor,titleColor: UIColor,borderColor:UIColor,subtitleColor: UIColor,shadowColor: UIColor) {
        self.view.backgroundColor = backgroundColor
        self.headingTextLabel.textColor = titleColor
        self.descriptionTextLabel.textColor = subtitleColor
        incomeVectorButtonOutlet.setTitleColor(borderColor, for: .normal)
        expenceVectorButtonOutlet.setTitleColor(borderColor, for: .normal)
        selectImageButtonOutlet.setImageView(imageName: selectedImageName, color: titleColor)
        selectImageButtonOutlet.layer.setMiddleShadow(color: shadowColor)
        scrollView.backgroundColor = .clear
        setupButtonsAndFields(subTitleColor: subtitleColor)
    }

    func visualSettings() {
        self.headingTextLabel.numberOfLines = 2
        self.headingTextLabel.minimumScaleFactor = 0.5
        self.headingTextLabel.font = .systemFont(ofSize: 34, weight: .bold)
        self.descriptionTextLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionTextLabel.numberOfLines = 0
        incomeVectorButtonOutlet.layer.cornerRadius = 10
        expenceVectorButtonOutlet.layer.cornerRadius = 10
        containerForSaveButton.backgroundColor =  .clear //colors.backgroundcolor
        selectDateButtonOutlet.mainButtonTheme("date_button")
        selectDateButtonOutlet.setImage(UIImage().getNavigationImage(systemName: "calendar.circle.fill", pointSize: 26, weight: .light), for: .normal)
        selectDateButtonOutlet.tintColor = colors.contrastColor1
        dateRhythmButton.backgroundColor = colors.secondaryBackgroundColor
        dateRhythmButton.layer.cornerRadius = 16
        dateRhythmButton.layer.cornerCurve = .continuous
        dateRhythmButton.setImage(UIImage().getNavigationImage(systemName: "arrow.2.squarepath", pointSize: 28, weight: .light), for: .normal)
        dateRhythmButton.setTitle("", for: .normal)
        dateRhythmButton.tintColor = colors.titleTextColor
        
        
        let income = UIImage(named: "income.button")
        let incomeTint = income?.withRenderingMode(.alwaysTemplate)
        let expence = UIImage(named: "expence.button")
        let expenceTint = expence?.withRenderingMode(.alwaysTemplate)
       
       
        
        incomeVectorButtonOutlet.setImage(incomeTint, for: .normal)
        incomeVectorButtonOutlet.tintColor = colors.backgroundcolor
        
        expenceVectorButtonOutlet.setImage(expenceTint, for: .normal)
        expenceVectorButtonOutlet.tintColor = colors.backgroundcolor
        
        let isEditingButtonTitle = isEditingScheduler ? NSLocalizedString("save_button", comment: "") : NSLocalizedString("create_button", comment: "")
        okButtonOutlet.mainButtonTheme(isEditingButtonTitle)
        selectImageButtonOutlet.layer.cornerRadius = 25
        scrollView.backgroundColor = .clear
    }
    func setupButtonsAndFields(subTitleColor: UIColor) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: subTitleColor ])
        
        let sumPerTimeText = newScheduleObject.stringScheduleType == .goal ? NSLocalizedString("available_sum", comment: "") : NSLocalizedString("sum_per_time_text_field", comment: "")
        totalSumTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("total_sum_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: subTitleColor])
        sumPerTimeTextField.attributedPlaceholder = NSAttributedString(string: sumPerTimeText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: subTitleColor])
        let title = isEditingScheduler ? newScheduleObject.currencyISO : mainCurrency!.ISO
        rightViewTextFieldButtonFor(title: title)
    }
}
