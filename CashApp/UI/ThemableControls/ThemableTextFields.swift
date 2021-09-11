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
    
    override func didMoveToWindow() {
        Themer.shared.register(target: self, action: ThemableTextField.defaultTheme(_:))
        super.didMoveToWindow()
    }
    
    func defaultTheme(_ theme: MyTheme) {
        self.backgroundColor = .clear
        self.layer.borderColor = theme.settings.borderColor.cgColor
        self.textColor = theme.settings.titleTextColor
        
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
        let shadowLayer = CAShapeLayer()
        shadowLayer.setSmallShadow(color: shadowColor)
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}