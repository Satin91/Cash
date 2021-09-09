//
//  VisualSettings.swift
//  CashApp
//
//  Created by Артур on 3.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

extension TodayBalanceViewController {
    
    func createConstraints() {
        initConstraints(view: containerForTableView, to: tableView)
//        calendarButtonContainerView.addSubview(calendarButton)
//        calendarButtonContainerView.addSubview(imageForCalendarButton)
//        initConstraints(view: imageForCalendarButton, to: calendarButtonContainerView)
//        initConstraints(view: calendarButton, to: calendarButtonContainerView)
    }
    func setupTableView() {
        self.view.addSubview(containerForTableView)
        self.view.bringSubviewToFront(tableView)
        containerForTableView.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TodayBalanceTableViewCell.nib(), forCellReuseIdentifier: TodayBalanceTableViewCell.identifier)
    }
    func installCalendar(){
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: DIYCalendarCell.identifier)
        //updateTotalBalanceSum(animated: true)
    }
    func visualSettings() {
        //view
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        containerView.backgroundColor = theme.secondaryBackgroundColor
        containerView.layer.setMiddleShadow(color: theme.shadowColor)
        containerView.layer.cornerRadius = 30
        circleBarContainerView.backgroundColor = theme.secondaryBackgroundColor
        circleBarContainerView.layer.cornerRadius = 20
        circleBarContainerView.layer.setSmallShadow(color: theme.shadowColor)
        segmentedControlOutlet.changeValuesForCashApp(segmentOne: NSLocalizedString("segmented_control_plans", comment: ""), segmentTwo: NSLocalizedString("segmented_control_accounts", comment: ""))
        calendarButtonOutlet.layer.cornerRadius = 12
        calendarButtonOutlet.backgroundColor = ThemeManager.currentTheme().contrastColor1
        calendarButtonOutlet.setImage(UIImage(named: "calendarForButton"), for: .normal)
        calendarButtonOutlet.setTitle("", for: .normal)
        calendarButtonOutlet.setImageTintColor(ThemeManager.currentTheme().backgroundColor)
        blur.frame = self.view.bounds
        calendar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.6)
        calendarContainerView.frame = calendar.frame
        //labels
        dailyBudgetLabel.textColor = theme.titleTextColor
        calculatedUntilDateLabel.textColor = theme.subtitleTextColor
        dailyBudgetBalanceLabel.textColor = theme.titleTextColor
        //labels font weight and size
        dailyBudgetLabel.font = .systemFont(ofSize: 19, weight: .medium)
        calculatedUntilDateLabel.font = .systemFont(ofSize: 16, weight: .regular)
        dailyBudgetBalanceLabel.font = .systemFont(ofSize: 46, weight: .medium)
        impactOnBalanceLabel.font = .systemFont(ofSize: 16, weight: .regular)
        impactOnBalanceLabel.text = NSLocalizedString("impact_on_balance_label", comment: "")
        impactOnBalanceLabel.textColor = ThemeManager.currentTheme().titleTextColor
        impactOnBalanceLabel.numberOfLines = 0
    }
    
}
