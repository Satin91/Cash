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
        let image = UIImage().getNavigationImage(systemName: "ellipsis", pointSize: 46, weight: .light)
        editButtonOutlet.setImage(image, for: .normal)
        editButtonOutlet.tintColor = colors.whiteColor
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
            
        }
    }
    
    // При выключении
    func disableConfiguration() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.editButtonOutlet.layer.shadowOpacity = 0.4
            self.editButtonOutlet.backgroundColor = self.colors.blackColor
        }
    }
}
