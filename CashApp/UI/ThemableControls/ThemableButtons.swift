//
//  ThemableButtons.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer


class MainButton: UIButton {
    func mainButtonTheme(_ withTitle: String) {
        self.layer.setSmallShadow(color: ThemeManager2.currentTheme().shadowColor)
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.contentHorizontalAlignment = .center
        self.setTitle(NSLocalizedString(withTitle, comment: ""), for: .normal)
        self.setTitleColor(ThemeManager2.currentTheme().backgroundColor, for: .normal)
        Themer.shared.register(target: self, action: MainButton.theme(_:))
    }
    func theme(_ theme: MyTheme) {
        backgroundColor = theme.settings.titleTextColor
        setTitleColor(theme.settings.backgroundColor, for: .normal)
    }
}
class ContrastButton: UIButton {
    
    func mainButtonTheme(_ withTitle: String) {
        self.layer.setSmallShadow(color: ThemeManager2.currentTheme().shadowColor)
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.contentHorizontalAlignment = .center
        self.setTitle(NSLocalizedString(withTitle, comment: ""), for: .normal)
        self.setTitleColor(ThemeManager2.currentTheme().backgroundColor, for: .normal)
        Themer.shared.register(target: self, action: ContrastButton.theme(_:))
    }
    func theme(_ theme: MyTheme) {
        backgroundColor = theme.settings.contrastColor1
        setTitleColor(theme.settings.backgroundColor, for: .normal)
    }
}

class ButtonWithImage: UIButton {
    override func didMoveToWindow() {
        Themer.shared.register(target: self, action: ButtonWithImage.theme(_:))
        super.didMoveToWindow()
    }
    
    func theme(_ theme: MyTheme) {
        backgroundColor = theme.settings.secondaryBackgroundColor
        imageView?.changePngColorTo(color: theme.settings.titleTextColor)
        //setTitleColor(theme.settings.backgroundColor, for: .normal)
    }

}
