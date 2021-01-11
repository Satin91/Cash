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
func changeSegmentAnimation (TableView: UITableView, ChangeValue: inout Bool) {
    let duration = 0.095
    let milliseconds = 95
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
        TableView.alpha = 0
    }, completion: nil)
    ChangeValue.toggle()
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: {
        UIView.animate(withDuration: duration, delay: duration, options: UIView.AnimationOptions.curveLinear, animations: {
            
            TableView.alpha = 1
            TableView.reloadData()
        }, completion: nil)
    })
    
}


