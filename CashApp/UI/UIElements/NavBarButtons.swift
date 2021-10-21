//
//  NavBarButtons.swift
//  CashApp
//
//  Created by Артур on 18.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class NavigationBarButtons {
    enum ButtonType: String {
        case back
        case cancel
        case add
        case none
        case calendar
        case settings
        case currency
        case chart
        var getRaw: String {
            switch self {
            case .back:
                return "chevron.backward"
            case .cancel:
                return ""
            case .add:
                return "plus.circle.fill"
            case .calendar:
                return "calendar"
            case .settings:
                return "slider.vertical.3"
            case .currency:
                guard let mainCurrency = mainCurrency else { return "" }
                return mainCurrency.ISO
            case .chart:
                return "chart.bar.doc.horizontal.fill"
                
            case .none:
                
                break
            }
            return ""
        }
    }
    let colors = AppColors()
    private var leftButton: ButtonType = .none
    private var rightButton: ButtonType = .none
    var item: UINavigationItem!
    
   
    
    init(navigationItem: UINavigationItem, leftButton: ButtonType, rightButton: ButtonType) {
        colors.loadColors()
        self.item = navigationItem
        self.leftButton = leftButton
        self.rightButton = rightButton
        createButtons()
        
    }
    
    private func createButtons(){
        
        if leftButton != .none {
            createLeftBarButtonItem(image: leftButton.getRaw)
        }
        if rightButton != .none {
            createRightBarButtonItem(image: rightButton.getRaw)
        }
    }
    var rightButtonAction: (() -> (Void))?
    var leftButtonAction: (() -> (Void))?
    
    @objc func rightButtonTapped(_ button: UIButton) {
        rightButtonAction?()
    }
    @objc func leftButtonTapped(_ button: UIButton) {
        leftButtonAction?()
    }
    func setLeftButtonAction(complete: @escaping () -> Void) {
        if leftButton != .none {
            leftButtonAction = complete
        }
    }
    func setRightButtonAction(complete: @escaping () -> Void) {
        if rightButton != .none {
            rightButtonAction = complete
        }
    }
    
    
    private func createRightBarButtonItem(image: String) {
        let customVuew = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 34))
        let button = UIButton()
        button.frame = CGRect(x: -12, y: 0, width: 50, height: 34)
        
        // СОри но я тороплюсь!!!
        if image == "" {
            button.setTitle(NSLocalizedString("cancel_button", comment: ""), for: .normal)
            button.setTitleColor(colors.contrastColor1, for: .normal)
            button.frame.size.width = 80
            button.frame.size.height = 40
            button.frame.origin.x = -42
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        } else {
            button.setTitle("", for: .normal)
            button.setImage(UIImage().getNavigationImage(systemName: image, pointSize: 34, weight: .light) , for: .normal)
        }
        
       
        button.contentHorizontalAlignment = .right
       
        
//        button.backgroundColor = colors.titleTextColor.withAlphaComponent(0.15)
//        button.layer.cornerRadius = 8
//        button.layer.cornerCurve = .continuous
        
        button.tintColor = colors.contrastColor1
         button.addTarget(self, action: #selector(rightButtonTapped(_:)), for: .touchUpInside)
        customVuew.addSubview(button)
        let rightBarButton = UIBarButtonItem(customView: customVuew)
        // let barButton = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
        item.rightBarButtonItem = rightBarButton
    }
    private func createLeftBarButtonItem(image: String) {
        let customVuew = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 34))
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 0, width: 50, height: 34)
        //button.setTitle(NSLocalizedString("back_button", comment: ""), for: .normal)
//        button.backgroundColor = colors.titleTextColor.withAlphaComponent(0.15)
//        button.layer.cornerRadius = 8
//        button.layer.cornerCurve = .continuous
        button.contentHorizontalAlignment = .left
        button.tintColor = colors.titleTextColor
        //button.setTitleColor(colors.titleTextColor.withAlphaComponent(0.15), for: .normal)
        button.setImage(UIImage().getNavigationImage(systemName: image, pointSize: 34, weight: .regular) , for: .normal)
         button.addTarget(self, action: #selector(leftButtonTapped(_:) ), for: .touchUpInside)
        customVuew.addSubview(button)
        let leftBarButton = UIBarButtonItem(customView: customVuew)
        // let barButton = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
        item.leftBarButtonItem = leftBarButton
    }
    
    
}
