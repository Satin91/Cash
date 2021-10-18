//
//  EditButtonSetup.swift
//  CashApp
//
//  Created by Артур on 16.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


extension AccountCollectionViewCell {
    // При появлении
    func baseConfiguration() {
        editButtonImage = UIImageView(image: UIImage(named: "editButton"))
        editButtonImage.setImageColor(color: colors.whiteColor)
        editButtonImage.frame = editButtonOutlet.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        editButtonImage.contentMode = .scaleAspectFill
        editButtonOutlet.addSubview(editButtonImage)
        editButtonOutlet.backgroundColor = colors.blackColor
        editButtonOutlet.layer.cornerRadius = 8
        editButtonOutlet.layer.cornerCurve = .continuous
        setStrongShadow()
    }
    
    func setStrongShadow() {
        editButtonOutlet.layer.shadowColor = colors.blackColor.cgColor
        editButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 6)
        editButtonOutlet.layer.shadowRadius = 8
        editButtonOutlet.layer.shadowOpacity = 0.4
    }
    
    // При включении
    func enableConfiguration() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.editButtonOutlet.layer.shadowOpacity = 0
            self.editButtonOutlet.backgroundColor =  self.colors.whiteColor.withAlphaComponent(0.6)
            
        } completion: { _ in
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self = self else { return }
                self.editButtonImage.setImageColor(color:  self.colors.blackColor.withAlphaComponent(0.8))
            }
        }
    }
    
    // При выключении
    func disableConfiguration() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.editButtonOutlet.layer.shadowOpacity = 0.4
            self.editButtonOutlet.backgroundColor = self.colors.blackColor
        } completion: { _ in
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self = self else { return }
                self.editButtonImage.setImageColor(color:  self.colors.whiteColor)
            }
        }
    }
}
