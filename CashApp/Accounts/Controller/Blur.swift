////
////  Blur.swift
////  CashApp
////
////  Created by Артур on 5.09.21.
////  Copyright © 2021 Артур. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class Blur: UIView {
//    
//    let blur: UIVisualEffectView = {
//        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
//       return visualEffect
//    }()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(blur)
//        blur.frame = self.bounds
//        blur.alpha = 0
//        
//    }
//    func showBlur(){
//        UIView.animate(withDuration: 0.2){ [weak self] in
//            self?.blur.alpha = 1
//        }
//    }
//    func hideBlur(){
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            self?.blur.alpha = 0
//        }
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
