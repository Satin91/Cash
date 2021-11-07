//
//  CurrencySearchBar.swift
//  CashApp
//
//  Created by Артур on 18.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CurrencySearchBar: ThemableTextField {

    var cancelButton: CancelButton!
    weak var navBar: UIView!
    init(frame: CGRect, cancelButton: CancelButton,navBar: UIView) {
        super.init(frame: frame)
        colors.loadColors()
        self.cancelButton = cancelButton
        self.navBar = navBar
        navBar.addSubview(self)
        createSearchBar()
        self.backgroundColor = .black
        createConstraints(toView: navBar, trailingAnchor: cancelButton)
        createSearchBar()
        createLeftView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.searchTheme(fillColor: colors.secondaryBackgroundColor, shadowColor: colors.shadowColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createLeftView() {
        let leftImageView = UIImageView(frame: CGRect(x: 4, y: 4, width: 22, height: 22))
        let image = UIImage().getNavigationImage(systemName: "magnifyingglass", pointSize: 22, weight: .regular)
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.image = image
        leftImageView.tintColor = colors.subtitleTextColor
        let iconContainerView: UIView = UIView(frame:
                          CGRect(x: 20, y: 0, width: 30, height: 30))
           iconContainerView.addSubview(leftImageView)
        self.leftView = iconContainerView
    }
     func createSearchBar(){

        self.leftViewMode = .always
        self.placeholder = NSLocalizedString("search_bar", comment: "")
        let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
        self.font = font
         self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: colors.subtitleTextColor])
        //navBar.addSubview(self)
       // createConstraints(toView: navBar, trailingAnchor: cancelButton)
    }
 
    func createConstraints(toView: UIView, trailingAnchor: UIView) {
        let topAnchConst: CGFloat = (toView.bounds.height - 34) / 2
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor,constant: 26).isActive = true
        self.heightAnchor.constraint(equalToConstant: 34).isActive = true
        self.topAnchor.constraint(equalTo: toView.topAnchor, constant: topAnchConst).isActive = true
        self.trailingAnchor.constraint(equalTo: trailingAnchor.leadingAnchor, constant: -22).isActive = true
        
    }

}
