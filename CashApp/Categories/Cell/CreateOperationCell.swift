//
//  CreateOperationCell.swift
//  CashApp
//
//  Created by Артур on 21.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer
import SwipeCellKit


class CreateOperationCell: UICollectionViewCell {
    let colors = AppColors()
    var dashColor: UIColor?
    static let identifier = "CreateOperationCell"
    static func nib() -> UINib {
        let nib = UINib(nibName: "CreateOperationCell", bundle: nil)
        return nib
    }
    let imageOfCreate: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "addCategory")
        //image.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        return image
    }()
    var lockView: LockView!
    let someView = UIView(frame: .zero)
    override func layoutSubviews() {
        super.layoutSubviews()
      //  initConstraints(view: dashView, to: self)
        createConstraints()
        lockView.isHidden = lock
    }
    var lock: Bool = false
    func lock(_ isLock: Bool) {
        lock = !isLock
        //lockView.isHidden = !isLock
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        layoutSubviews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        Themer.shared.register(target: self, action: CreateOperationCell.theme(_:))
        self.colors.loadColors()
        self.contentView.addSubview(imageOfCreate)
        self.clipsToBounds = false
        dashView = UIView(frame: .zero )
        self.addSubview(dashView)
        
       
      
      //  self.addSubview(someView)
    }
    var dashView: UIView!
    var border =  CAShapeLayer()
    

    func createConstraints() {
        let height = self.bounds.height - 17 - 5 - 2 // 17 - высота лейбла, 5 - констрейнт до лейбла, 2 - толщина линии
        Themer.shared.register(target: self, action: CreateOperationCell.theme(_:))
        dashView.translatesAutoresizingMaskIntoConstraints = false
        dashView.clipsToBounds = false
        dashView.layer.masksToBounds = false
        dashView.layer.cornerRadius = 15
        dashView.backgroundColor = .clear
        
        //dashView.drawDash(radius: 12, color: dashColor!)
        dashView.drawDash(radius: 12, layer: self.border)
        //dashView.topAnchor.constraint(equalTo: topAnchor,constant: -height).isActive = true
        dashView.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: -2).isActive = true
        dashView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dashView.heightAnchor.constraint(equalToConstant: height ).isActive = true
        dashView.widthAnchor.constraint(equalToConstant: height).isActive = true
        imageOfCreate.translatesAutoresizingMaskIntoConstraints = false
        imageOfCreate.topAnchor.constraint(equalTo: dashView.topAnchor).isActive = true
        imageOfCreate.bottomAnchor.constraint(equalTo: dashView.bottomAnchor).isActive = true
        imageOfCreate.leadingAnchor.constraint(equalTo: dashView.leadingAnchor).isActive = true
        imageOfCreate.trailingAnchor.constraint(equalTo: dashView.trailingAnchor).isActive = true
        
        
        lockView = LockView(frame: dashView.bounds)
        lockView.addLock(to: dashView, lockSize: .category)
        self.lockView.isHidden = true
        


    }
    func createLock() {
        
    }
}
extension CreateOperationCell {
    func theme(_ theme: MyTheme) {
        imageOfCreate.changePngColorTo(color: theme.settings.titleTextColor)
        backgroundColor = theme.settings.backgroundColor
        self.dashColor = theme.settings.borderColor
        self.border.strokeColor = theme.settings.borderColor.cgColor
        
    }
}
