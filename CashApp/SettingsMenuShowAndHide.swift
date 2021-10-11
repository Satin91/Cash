//
//  SettingsMenuShowAndHide.swift
//  CashApp
//
//  Created by Артур on 6.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension SettingsMenu {

    func openOrCloseSettingsMenu(isTappedMenuAnyTime: inout Bool ){
        let x = self.originPoint.x
        let y = self.originPoint.y
        let width: CGFloat = parentView.bounds.width * 0.7
        let height = self.totalHeight
        let frame = CGRect(x: x, y: y, width: width, height: height)
        

        if isTappedMenuAnyTime == false {
            self.frame = frame
            self.transform = CGAffineTransform.identity.translatedBy(x: -width / 2, y: -height / 2).scaledBy(x: 0.01, y: 0.01)
            isTappedMenuAnyTime = true
        }
        
        
        if self.isHidden == false{
            UIView.animate(withDuration: 0.3, animations: {
                self.visualEffect.alpha = 0
                self.transform = CGAffineTransform.identity.translatedBy(x: -width / 2, y: -height / 2).scaledBy(x: 0.01, y: 0.01)
            }, completion: { _ in
                self.isHidden = true
            })
            
        } else {
            //if True
            self.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.visualEffect.alpha = 1
                self.transform = CGAffineTransform.identity
                
            })
        }
        
        
    }
}

