//
//  Shadows.swift
//  CashApp
//
//  Created by Артур on 22.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


extension CALayer {
    
    public func setMiddleShadow(color: UIColor) {
           shadowColor = color.cgColor
           shadowOffset = CGSize(width: 0, height: 10)
           //shadowPath = UIBezierPath(rect: bounds).cgPath
           // shouldRasterize = true
           shadowRadius = 30
        shadowOpacity = 0.06
           shouldRasterize = true
           rasterizationScale = UIScreen.main.scale
       }
    public func setSmallShadow(color: UIColor) {
        shadowColor = color.cgColor
        shadowOffset = CGSize(width: 2, height: 8)
        shadowRadius = 20
        shadowOpacity = 0.06
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    public func setCircleShadow(color: UIColor) {
        shadowColor = color.cgColor
        shadowOffset = CGSize(width: 0, height: 0)
        shadowRadius = 5
        shadowOpacity = 0.4
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
}
