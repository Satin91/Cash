//
//  QuickPayNavigationButtons.swift
//  CashApp
//
//  Created by Артур on 14.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class QuickPayNavigationButtons {
   private let colors = AppColors()
    enum ButtonType{
        case backward
        case foward
    }
    
    weak var parentView: UIView!
    let localizedTitle = NSLocalizedString("back_button", comment: "")
    init(parentView: UIView) {
        self.parentView = parentView
        colors.loadColors()
        self.parentView.addSubview(backwardButton)
        self.parentView.addSubview(fowardButton)
        buttonsActions()
    }
    func buttonsActions() {
        fowardButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
   private var tappedAction: (() -> Void)?
    
    func didTapped(action: @escaping () -> Void ) {
        self.tappedAction = action
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        tappedAction?()
    }
    
    func putOnView(_ button: ButtonType) {
        let parentHeight = parentView.bounds.height
        let btnWidth: CGFloat = 120 // Ширина заметно больше чтобы пальцем удобно было нажимать
        let btnHeight: CGFloat = 34
        let side: CGFloat = 26
        let btnY: CGFloat = (parentHeight - btnHeight) / 2
        let fwrdX = parentView.bounds.width / 3 - btnWidth - side
        let bkwdX = (parentView.bounds.width / 3) * 2 + side
        
        switch button {
        case .backward:
            backwardButton.frame = CGRect(x: bkwdX, y: btnY, width: btnWidth, height: btnHeight)
            
        case .foward:
            fowardButton.frame = CGRect(x: fwrdX, y: btnY, width: btnWidth, height: btnHeight)
           
        }
    }
  
    
    
    //MARK: Create backward Button
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("" + localizedTitle, for: .normal)
        button.setTitleColor(colors.titleTextColor, for: .normal)
        button.setImage(UIImage().getNavigationImage(systemName: "chevron.left", pointSize: 26, weight: .medium), for: .normal) // Местный метод по заданию иконки
        button.contentHorizontalAlignment = .left  // сдвигает контнт влево
        button.tintColor = colors.contrastColor1
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    
    //MARK: Create foward Button
    private lazy var fowardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("" + localizedTitle, for: .normal)
       
        button.setTitleColor(colors.titleTextColor, for: .normal)
        button.setImage(UIImage().getNavigationImage(systemName: "chevron.right", pointSize: 26, weight: .medium),for: .normal) // Местный метод по заданию иконки
        button.contentHorizontalAlignment = .right // сдвигает контнт вправо
        button.tintColor = colors.contrastColor1
        button.semanticContentAttribute = .forceRightToLeft
//        if #available(iOS 15.0, *) {
//            button.configuration?.titlePadding = 15
//        } else {
//            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
//            // Fallback on earlier versions
//        }
        return button
    }()
    
}


