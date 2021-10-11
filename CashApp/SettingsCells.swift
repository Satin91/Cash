//
//  SettingsCells.swift
//  CashApp
//
//  Created by Артур on 5.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer

class SettingsThemeTableViewCell: UITableViewCell {
    
    var separatorView: UIView!
    lazy var config = self.defaultContentConfiguration()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorView = SeparatorView(cell: self).createLineViewWithConstraints()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Themer.shared.register(target: self, action: SettingsThemeTableViewCell.theme(_:))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingsNotificationTableViewCell: UITableViewCell {
    var separatorView: UIView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorView = SeparatorView(cell: self).createLineViewWithConstraints()
        Themer.shared.register(target: self, action: SettingsNotificationTableViewCell.theme(_:))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SettingsSubscriptionTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsThemeTableViewCell {
    func theme(_ theme: MyTheme) {
        separatorView.backgroundColor = theme.settings.separatorColor
        self.config.textProperties.color = theme.settings.redColor
        self.config.imageProperties.tintColor = theme.settings.titleTextColor
    }
}
extension SettingsNotificationTableViewCell {
    func theme(_ theme: MyTheme) {
        separatorView.backgroundColor = theme.settings.separatorColor
        
    }
}
