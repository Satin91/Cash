//
//  neomorphicView.swift
//  CashApp
//
//  Created by Артур on 7/27/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class NeomorphicView: UIView {
    
    
    @IBOutlet var contentView: UIView!
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            setshadow()
        }
    }
    @IBInspectable var shadowSize: Int = 0{
        didSet{
            setshadow()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            setshadow()
        }
    }
    override init(frame: CGRect){
        super.init(frame:frame)
  
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        self.backgroundColor = nil
    }
    
    
    private func commonInit() {
       // Bundle.main.loadNibNamed("NeomorphicView", owner: self, options: nil)
//        addSubview(contentView)
//        setupContentView()
   
    }

    var darkShadow = CALayer()
    var lightShadow = CALayer()
    var backgroundContentView = CALayer()
    
    func setshadow() {
        
        backgroundContentView.cornerRadius = cornerRadius
        backgroundContentView.frame = self.bounds
        backgroundContentView.backgroundColor = whiteThemeBackground.cgColor
        self.layer.insertSublayer(backgroundContentView, at: 0)
        
        darkShadow.frame = self.bounds
        darkShadow.cornerRadius = backgroundContentView.cornerRadius
        darkShadow.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        darkShadow.shadowColor = #colorLiteral(red: 0.5019607843, green: 0.5960784314, blue: 0.6666666667, alpha: 1)
        darkShadow.shadowOffset = CGSize(width: shadowSize, height: shadowSize) // Размер
        darkShadow.shadowOpacity = 0.4
        darkShadow.shadowRadius = shadowRadius //Радиус
        self.layer.insertSublayer(darkShadow, at: 0)
        
        lightShadow.frame = self.bounds
        lightShadow.cornerRadius = backgroundContentView.cornerRadius
        lightShadow.backgroundColor = whiteThemeBackground.cgColor
        lightShadow.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lightShadow.shadowOffset = CGSize(width: -shadowSize, height: -shadowSize) // Размер
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius // Радиус
        self.layer.insertSublayer(lightShadow, at: 1)
    }
    
    
    
    func setupCornerRadius() {
        backgroundContentView.frame = self.bounds
        self.frame = self.bounds
        self.layer.cornerRadius = cornerRadius
        self.layer.addSublayer(backgroundContentView)
        backgroundContentView.cornerRadius = cornerRadius
    }
    
    //пока нужная вещь, потом нет
    func setupContentView() {
        self.contentView.isHidden = false
        
        contentView.bounds = self.frame
        contentView.layer.cornerRadius = 70
        self.contentView.layer.cornerRadius = 70
        contentView.layer.isHidden = false
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.clipsToBounds = true
    }
    
    
    
}



