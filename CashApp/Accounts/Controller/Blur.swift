////
////  Blur.swift
////  CashApp
////
////  Created by Артур on 5.09.21.
////  Copyright © 2021 Артур. All rights reserved.
////

import Foundation
import UIKit
import Themer
class BlurView: UIView {
    
    let blur: UIVisualEffectView = {
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style:Themer.shared.theme == .dark ? .systemThinMaterialDark:.systemThinMaterialLight ))
       return visualEffect
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(blur)
        blur.frame = self.bounds
        blur.alpha = 0
        self.isUserInteractionEnabled = false
        
    }
    func showBlur(){
        
            self.blur.alpha = 1
        self.blur.isUserInteractionEnabled = true
    }
    func hideBlur(){
        
            self.blur.alpha = 0
            self.blur.isUserInteractionEnabled = false
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
