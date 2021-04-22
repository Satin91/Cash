//
//  ProgressBar.swift
//  CashApp
//
//  Created by Артур on 17.03.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
 
    
    var sizeView = UIView()
    
    
    private var innerProgress: CGFloat = 0.0
    var progress : CGFloat {
      set (newProgress) {
        if newProgress > 1.0 {
          innerProgress = 1.0
        } else if newProgress < 0.0 {
          innerProgress = 0
        } else {
          innerProgress = newProgress
        }
        setNeedsDisplay()
      }
      get {
        return innerProgress * bounds.width
      }
    }
    override func draw(_ rect: CGRect) {
        self.backgroundColor = whiteThemeTranslucentText
        self.layer.cornerRadius = self.bounds.height / 2
        
        CustomProgressBar.drawProgressBar(frame: bounds, backgroundColor: self.backgroundColor!, progress: progress)
        self.clipsToBounds = true
    }
    
    

}

