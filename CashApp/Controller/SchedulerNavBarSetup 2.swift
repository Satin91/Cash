//
//  SchedulerNavBarSetup.swift
//  CashApp
//
//  Created by Артур on 15.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer
extension SchedulerViewController {
 
    func setupRightButton() {
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(SchedulerViewController.createTransition(_:))
    }
    func setupNavBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        
        appearance.backgroundEffect = UIBlurEffect(style: Themer.shared.theme == .light ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark) // or dark
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .regular),NSAttributedString.Key.foregroundColor: colors.titleTextColor]
        let scrollingAppearance = UINavigationBarAppearance()
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 26 - 12
        paragraphStyle.alignment = .left
        
        scrollingAppearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 46, weight: .medium), .paragraphStyle: paragraphStyle, .foregroundColor: colors.titleTextColor  ]
        
        scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = .clear // your view (superview) color
        scrollingAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .regular),NSAttributedString.Key.foregroundColor: colors.titleTextColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollingAppearance
        navigationController?.navigationBar.compactAppearance = scrollingAppearance
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < -60 {
//               navigationController?.setNavigationBarHidden(true, animated: true)
//           } else {
//               navigationController?.setNavigationBarHidden(false, animated: true)
//           }
//    }
    
}
