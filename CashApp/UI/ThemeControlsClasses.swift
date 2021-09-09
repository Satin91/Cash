//
//  ThemeControlsClasses.swift
//  CashApp
//
//  Created by Артур on 9.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

class TitleLabel: UILabel, Themable {
    
    func applyTheme(_ theme: MyTheme) {
        textColor = theme.settings.titleTextColor
        
    }
    override func didMoveToWindow() {
        ThemManager.shared.register(self)
        super.didMoveToWindow()
    }
}

class SubtitleLabel: UILabel, Themable {
    func applyTheme(_ theme: MyTheme) {
        textColor = theme.settings.subtitleTextColor
    }
    override func didMoveToWindow() {
        ThemManager.shared.register(self)
        super.didMoveToWindow()
    }
}
class ThemebleImageView: UIImageView, Themable {
    func applyTheme(_ theme: MyTheme) {
        setImageColor(color: theme.settings.titleTextColor)
    }
    
    override func didMoveToWindow() {
        
        ThemManager.shared.register(self)
        super.didMoveToWindow()
    }
}
    

                         
                         

