//
//  Animations.swift
//  CashApp
//
//  Created by Артур on 10/21/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import Foundation
import UIKit

//TableViewsAnimation for segmented control


var tabbarOrigin: CGPoint! // пока не используется, нужен для фиксации tab bar
extension UITabBar {
    
    func showTabBar() {
        if self.isHidden == true {
            self.isHidden = false
            UIView.animate(withDuration: 0.5) {
                UIView.animate(withDuration: 1) {
                    
                    self.frame.origin.y = self.frame.origin.y - self.frame.height

                }
        }
        }
    }
    func hideTabBar() {
        if self.isHidden == false {
            
            UIView.animate(withDuration: 0.5) {
                UIView.animate(withDuration: 1) {
                    self.frame.origin.y = self.frame.origin.y + self.frame.height
            } completion: { (true) in
                self.isHidden = true
            }
        }
        }
}
}


