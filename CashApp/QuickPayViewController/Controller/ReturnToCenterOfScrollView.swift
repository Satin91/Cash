//
//  ReturnToCenterOfScrollView.swift
//  CashApp
//
//  Created by Артур on 13.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class ReturnToCenterOfScrollView {
  
    static func returnToCenter(scrollView: UIScrollView){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            scrollView.setContentOffset(CGPoint(x:  scrollView.bounds.width, y: scrollView.bounds.origin.y), animated: true)
        }
      
    }
}
