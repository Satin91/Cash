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
        Themer.shared.register(target: self, action: MainButton.theme(_:))
    }
    
    func theme(_ theme: MyTheme) {
        backgroundColor = theme.settings.titleTextColor
        setTitleColor(theme.settings.backgroundColor, for: .normal)
    }
}
class ContrastButton: UIButton {
    let colors = AppColors()
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.getColor
            }
        }
    }
    var getColor: UIColor {
        get {
            var color: UIColor
            switch self.isEnabled {
            case true:
                color = colors.contrastColor1
            case false:
                color = colors.titleTextColor.withAlphaComponent(0.15)
            }
            return color
        }
    }
    func mainButtonTheme(_ withTitle: String) {
        colors.loadColors()
        backgroundColor = getColor
        self.layer.setSmallShadow(color: ThemeManager2.currentTheme().shadowColor)
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.contentHorizontalAlignment = .center
        self.setTitle(NSLocalizedString(withTitle, comment: ""), for: .normal)
        Themer.shared.register(target: self, action: ContrastButton.theme(_:))
    }
    func theme(_ theme: MyTheme) {
        backgroundColor = getColor
        setTitleColor(theme.settings.backgroundColor, for: .normal)
        setTitleColor(theme.settings.subtitleTextColor, for: .disabled)
    }
}
class SecondaryButton: UIButton {
    
    func mainButtonTheme(_ withTitle: String) {
        let colors = AppColors()
        colors.loadColors()
        self.layer.setSmallShadow(color: colors.shadowColor)
        self.layer.borderColor = colors.borderColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.contentHorizontalAlignment = .center
        
        self.setTitle(NSLocalizedString(withTitle, comment: ""), for: .normal)
        Themer.shared.register(target: self, action: SecondaryButton.theme(_:))
    }
    func theme(_ theme: MyTheme) {
        backgroundColor = theme.settings.secondaryBackgroundColor
        setTitleColor(theme.settings.titleTextColor, for: .normal)
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
