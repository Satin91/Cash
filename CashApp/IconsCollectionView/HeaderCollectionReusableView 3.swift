//
//  HeaderCollectionReusableView.swift
//  CashApp
//
//  Created by Артур on 19.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    let colors = AppColors()
 static let identifier = "HeaderCollectionReusableView"
     let label: UILabel = {
        let label = UILabel()
        label.text = "Header"
         label.font = UIFont(name: "SFProText-Regular", size: 22)
             //.systemFont(ofSize: 26, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    public func configure() {
        colors.loadColors()
        label.textColor = colors.titleTextColor
        backgroundColor = colors.titleTextColor.withAlphaComponent(0.04)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
    }
}
