//
//  CreateOperationCell.swift
//  CashApp
//
//  Created by Артур on 21.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CreateOperationCell: UICollectionViewCell {
    
    @IBOutlet weak var dashView: UIView!
    static let identifier = "CreateOperationCell"
    static func nib() -> UINib {
        let nib = UINib(nibName: "CreateOperationCell", bundle: nil)
        return nib
    }
    let imageOfCreate: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "addCategory")
        image.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
        return image
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        //initConstraints(view: dashView, to: self)
        createConstraints()
        dashView.drawDash(radius: 12)
        
      
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(imageOfCreate)
        dashView.backgroundColor = .clear
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        // Initialization code
    }
    
    func createConstraints() {
        let height = self.bounds.height - 17 - 5 - 2 // 17 - высота лейбла, 5 - констрейнт до лейбла, 2 - толщина линии
        
        dashView.translatesAutoresizingMaskIntoConstraints = false
        
        //dashView.topAnchor.constraint(equalTo: topAnchor,constant: -height).isActive = true
        dashView.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: -2).isActive = true
        dashView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dashView.heightAnchor.constraint(equalToConstant: height ).isActive = true
        dashView.widthAnchor.constraint(equalToConstant: height).isActive = true
        imageOfCreate.translatesAutoresizingMaskIntoConstraints = false
        imageOfCreate.topAnchor.constraint(equalTo: self.dashView.topAnchor).isActive = true
        imageOfCreate.bottomAnchor.constraint(equalTo: self.dashView.bottomAnchor).isActive = true
        imageOfCreate.leadingAnchor.constraint(equalTo: self.dashView.leadingAnchor).isActive = true
        imageOfCreate.trailingAnchor.constraint(equalTo: self.dashView.trailingAnchor).isActive = true
    }
    
    
}
