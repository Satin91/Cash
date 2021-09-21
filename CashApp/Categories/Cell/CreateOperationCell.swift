//
//  CreateOperationCell.swift
//  CashApp
//
//  Created by Артур on 21.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer


class CreateOperationCell: UICollectionViewCell {
    let colors = AppColors()
    
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
    override func layoutSubviews() {
        super.layoutSubviews()
      //  initConstraints(view: dashView, to: self)
        
        
        createConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layoutSubviews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colors.loadColors()
        self.contentView.addSubview(imageOfCreate)
        dshView = UIView(frame: self.bounds )
        self.addSubview(dshView)
        dshView.translatesAutoresizingMaskIntoConstraints = false
        
        Themer.shared.register(target: self, action: CreateOperationCell.theme(_:))
    }
    var dshView: UIView!
    
    func createConstraints() {
        let height = self.bounds.height - 17 - 5 - 2 // 17 - высота лейбла, 5 - констрейнт до лейбла, 2 - толщина линии
        
        colors.loadColors()
        dshView.layer.cornerRadius = 15
        dshView.backgroundColor = .clear
        dshView.drawDash(radius: 12, color: colors.borderColor)
        
 
        //dashView.topAnchor.constraint(equalTo: topAnchor,constant: -height).isActive = true
        dshView.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: -2).isActive = true
        dshView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dshView.heightAnchor.constraint(equalToConstant: height ).isActive = true
        dshView.widthAnchor.constraint(equalToConstant: height).isActive = true
        imageOfCreate.translatesAutoresizingMaskIntoConstraints = false
        imageOfCreate.topAnchor.constraint(equalTo: dshView.topAnchor).isActive = true
        imageOfCreate.bottomAnchor.constraint(equalTo: dshView.bottomAnchor).isActive = true
        imageOfCreate.leadingAnchor.constraint(equalTo: dshView.leadingAnchor).isActive = true
        imageOfCreate.trailingAnchor.constraint(equalTo: dshView.trailingAnchor).isActive = true
        
    }
}
extension CreateOperationCell {
    func theme(_ theme: MyTheme) {
        imageOfCreate.changePngColorTo(color: theme.settings.titleTextColor)
        backgroundColor = theme.settings.backgroundColor
       
    }
}
