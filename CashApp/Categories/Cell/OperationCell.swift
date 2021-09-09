//
//  OperationCell.swift
//  CashApp
//
//  Created by Артур on 18.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class OperationCell: UICollectionViewCell {
    
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " "
        label.textColor = ThemeManager.currentTheme().subtitleTextColor
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let roundedRect: UIView = {
        let rect = UIView()
        rect.layer.cornerRadius = 12
        rect.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        rect.translatesAutoresizingMaskIntoConstraints = false
        rect.layer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)
        return rect
    }()
    let categoryImage: UIImageView = {
        let image = UIImageView()
        
        
        return image
        
    }()
    fileprivate func visualSettings() {
        categoryImage.image = UIImage(named: "AppIcon")
        
        layer.masksToBounds = false
    }
    
    func set(object: MonetaryCategory) {
        categoryImage.image = UIImage(named: object.image)
        label.text = object.name
        categoryImage.changePngColorTo(color: ThemeManager.currentTheme().titleTextColor)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        createConstraints()
        visualSettings()
        
    }
    static func nib() -> UINib {
        let nib = UINib(nibName: "OperationCell", bundle: nil)
        return nib
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryImage.widthAnchor.constraint(equalToConstant: roundedRect.bounds.width * 0.6).isActive = true
        categoryImage.heightAnchor.constraint(equalToConstant: roundedRect.bounds.height * 0.6).isActive = true
        
    }
    func createConstraints() {
        self.addSubview(label)
        self.addSubview(roundedRect)
        
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //roundedRect.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //roundedRect.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        roundedRect.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 5).isActive = true
        roundedRect.bottomAnchor.constraint(equalTo:  bottomAnchor).isActive = true
        roundedRect.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        roundedRect.widthAnchor.constraint(equalTo: roundedRect.heightAnchor).isActive = true
        
        
    
        self.roundedRect.addSubview(categoryImage)
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.centerYAnchor.constraint(equalTo: roundedRect.centerYAnchor).isActive = true
        categoryImage.centerXAnchor.constraint(equalTo: roundedRect.centerXAnchor).isActive = true
       // categoryImage.widthAnchor.constraint// .isActive = true
        //categoryImage.heightAnchor.constraint(equalTo: roundedRect.heightAnchor, multiplier: 1.0).isActive = true
//        categoryImage.trailingAnchor.constraint(equalTo: roundedRect.trailingAnchor).isActive = true
//        categoryImage.leadingAnchor.constraint(equalTo: roundedRect.leadingAnchor).isActive = true
//        categoryImage.topAnchor.constraint(equalTo: roundedRect.bottomAnchor).isActive = true
//        categoryImage.bottomAnchor.constraint(equalTo:  roundedRect.bottomAnchor).isActive = true
        
        
    }
}
