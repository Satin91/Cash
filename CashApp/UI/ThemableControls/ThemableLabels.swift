//
//  ThemableLabels.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer

class TitleLabel: UILabel {
   
    override func didMoveToWindow() {
        Themer.shared.register(target: self, action: TitleLabel.theme(_:))
        super.didMoveToWindow()
    }
}
extension TitleLabel {
    func theme(_ theme: MyTheme) {
        textColor = theme.settings.titleTextColor
    }
}

class SubTitleLabel: UILabel {
    override func didMoveToWindow() {
        Themer.shared.register(target: self, action: SubTitleLabel.theme(_:))
        super.didMoveToWindow()
    }
    func theme(_ theme: MyTheme) {
        textColor = theme.settings.subtitleTextColor
    }
}
