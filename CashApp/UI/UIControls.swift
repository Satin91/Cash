//
//  UIControls.swift
//  CashApp
//
//  Created by Артур on 2.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func mainButtonTheme(color : UIColor,_ withTitle: String) {
        self.layer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)
        self.layer.cornerRadius = 16
        self.backgroundColor = color
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.contentHorizontalAlignment = .center
        self.setTitle(NSLocalizedString(withTitle, comment: ""), for: .normal)
        self.setTitleColor(ThemeManager.currentTheme().backgroundColor, for: .normal)
    }
}


