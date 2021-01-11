//
//  BorderButtomView.swift
//  CashApp
//
//  Created by Артур on 17.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import Foundation
import UIKit

class BorderButtonView: UIView {
 
    
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.layer.borderWidth = 3
        view.layer.borderColor = whiteThemeBackground.cgColor
        
        return view
    }()
    
    let view2: UIView = {
        let view = UIView()
        view.layer.borderWidth = 3
        view.layer.borderColor = whiteThemeBackground.cgColor    
        return view
    }()
    
let textField = UITextField()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSettings()
        shadowForView()
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSettings()
        shadowForView()
        setShadow()
        self.backgroundColor = .clear
    }
    var sh = CALayer()
    let shadow = CALayer()
    var backgroundContentView = CALayer()
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    
   
    
    
    func setShadow() {
        darkShadow.frame = self.bounds
        darkShadow.cornerRadius = backgroundContentView.cornerRadius
        darkShadow.backgroundColor = whiteThemeBackground.cgColor
        darkShadow.shadowColor = #colorLiteral(red: 0.5019607843, green: 0.5960784314, blue: 0.6666666667, alpha: 1)
        darkShadow.shadowOffset = CGSize(width: 1, height: 1) // Размер
        darkShadow.shadowOpacity = 0.4
        darkShadow.shadowRadius = 1 //Радиус
        self.layer.insertSublayer(darkShadow, at: 0)
        
        lightShadow.frame = self.bounds
        lightShadow.cornerRadius = backgroundContentView.cornerRadius
        lightShadow.backgroundColor = whiteThemeBackground.cgColor
        lightShadow.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lightShadow.shadowOffset = CGSize(width: -1, height: -1) // Размер
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = 2 //Радиус
        self.layer.insertSublayer(lightShadow, at: 1)
    }
    
    func setupShadow() {
        backgroundContentView.cornerRadius = 15
        backgroundContentView.frame = self.bounds
        backgroundContentView.backgroundColor = whiteThemeBackground.cgColor
        shadow.frame = self.bounds
        shadow.shadowColor = UIColor.darkGray.cgColor
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowRadius = 4
        shadow.shadowOpacity = 1
        shadow.cornerRadius = view2.frame.height / 2
        shadow.shadowPath = UIBezierPath(ovalIn: self.bounds).cgPath
    }
    func shadowForView() {
        view2.setShadow(view: view2, size: CGSize(width: -1, height: -1), opacity: 1, radius: 2, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        view.setShadow(view: view, size: CGSize(width: 1, height: 1), opacity: 1, radius: 2, color: #colorLiteral(red: 0.7137254902, green: 0.7647058824, blue: 0.8, alpha: 1))
    }
    func viewSettings() {
        self.layer.cornerRadius = 8
        view2.frame = self.bounds
        view2.layer.cornerRadius = view2.bounds.height / 2
        view2.clipsToBounds = true
        view2.backgroundColor = .none
        self.layer.masksToBounds = false
        view.frame = self.bounds
        view.layer.cornerRadius = view2.bounds.height / 2
        view.clipsToBounds = true
        view.backgroundColor = .none
        backgroundContentView.cornerRadius = self.frame.size.height / 2

        
        
        self.insertSubview(view2, at: 0)
        self.insertSubview(view, at: 0)
        self.layer.addSublayer(shadow)
        //self.layer.insertSublayer(backgroundContentView, at: 0)
        self.backgroundColor = . clear
    }
    
}
