//
//  ThemableTextFields.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//


import UIKit
import Themer

class ThemableTextField: UITextField {
    var updateTextColor: Bool = true
    let colors = AppColors()
    override func didMoveToWindow() {
        colors.loadColors()
        Themer.shared.register(target: self, action: ThemableTextField.defaultTheme(_:))
        super.didMoveToWindow()
    }
    
    func defaultTheme(_ theme: MyTheme) {
        self.backgroundColor = .clear
        self.layer.borderColor = theme.settings.borderColor.cgColor
        if updateTextColor == true {
            self.textColor =  theme.settings.titleTextColor
        }
        indent(size: 17)
    }
}

extension ThemableTextField {
    
    func borderedTheme(fillColor: UIColor, shadowColor: UIColor) {
        self.borderStyle = .none
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.layer.borderWidth = 1
        self.font = .systemFont(ofSize: 17, weight: .regular)
        self.textAlignment = .left
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.setSmallShadow(color: shadowColor)
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.cornerCurve = .continuous
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    func searchTheme(fillColor: UIColor, shadowColor: UIColor) {
        self.borderStyle = .none
        self.layer.cornerRadius = 8
        self.layer.cornerCurve = .continuous
        //self.layer.borderWidth = 1
        self.font = .systemFont(ofSize: 17, weight: .regular)
        self.textAlignment = .left
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.backgroundColor = fillColor
    }
}
