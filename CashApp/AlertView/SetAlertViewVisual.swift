//
//  SetImageToMiniAlert.swift
//  CashApp
//
//  Created by Артур on 8.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

    class SetAlertViewVisual {
        
        
        
        func setImage(alertStyle: MiniAlertStyle) -> UIImage {
            let image: UIImage
            
            switch alertStyle {
            case .success:
                image = UIImage(named: "alert.success")!
            case .warning:
                image = UIImage(named: "alert.warning")!
            case .error:
                image = UIImage(named: "alert.error")!
            case .date:
                image = UIImage(named: "prompt.calendar")!
            case .textFields:
                image = UIImage(named: "prompt.textField")!
            case .moreThan:
                image = UIImage(named: "prompt.moreThan")!
            case .image:
                image = UIImage(named: "prompt.image")!
                
            }
            return image
        }
        func setBackgroundColor( alertStyle: MiniAlertStyle) -> UIColor {
            let color: UIColor
            let promptBackground = ThemeManager2.currentTheme().titleTextColor
            switch alertStyle {
            case .success:
                color = ThemeManager2.currentTheme().greenColor
            case .warning:
                color = ThemeManager2.currentTheme().yellowColor
            case .error:
                color = ThemeManager2.currentTheme().redColor
            case .date:
                color = promptBackground
            case .textFields:
                
                color = promptBackground
            case .moreThan:
                color = promptBackground
            case .image:
                color = promptBackground
            }
            return color
        }
        
        
    }
    
    
