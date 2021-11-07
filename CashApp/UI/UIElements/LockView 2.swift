//
//  LockView.swift
//  CashApp
//
//  Created by Артур on 27.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer


final class LockView: UIView {

    enum LockSize {
        case category
        case plan
        case account
    }
let colors = AppColors()

       var image: UIImageView = {
       let image = UIImageView()
           
        image.image = UIImage(named: "subscribe.lock")
        return image
    }()
    
    var blur: UIVisualEffectView!
    
    func lock(_ isLock: Bool) {
        self.isHidden = isLock
    }
    
    func addLock(to: UIView, lockSize: LockSize) {
        switch lockSize {
        case .category:
            addCategoryLock(to: to)
        case .plan:
            addPlanLock(to: to)
        case .account:
            addAccountLock(to: to)
        }
    }
    private func addPlanLock(to: UIView) {
        Themer.shared.register(target: self, action: LockView.theme(_:))
        createPlanLockConstraints(to: to)
        self.layer.cornerRadius = 12
        self.backgroundColor = .clear
    }
    
    private func addCategoryLock(to: UIView) {
        let fractionalWidth: CGFloat = 2.7
        Themer.shared.register(target: self, action: LockView.theme(_:))
        createCategoryLockConstraints(to: to, fractionalWidth: fractionalWidth)
        let width = to.bounds.width / fractionalWidth
        self.layer.cornerRadius = width / 2
    }
    private func addAccountLock(to: UIView) {
        let fractionalWidth: CGFloat = 8
        Themer.shared.register(target: self, action: LockView.theme(_:))
        createCategoryLockConstraints(to: to, fractionalWidth: fractionalWidth)
        let width = to.bounds.width / fractionalWidth
        self.layer.cornerRadius = width / 2
    }
    
    
    
    private func createCategoryLockConstraints(to: UIView, fractionalWidth: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(image)
        to.addSubview(self)
        let width = to.bounds.width / fractionalWidth
        let x = to.bounds.width - (width / 2)
        let imageInset: CGFloat = 4
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: width).isActive = true
        self.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: x).isActive = true
        self.topAnchor.constraint(equalTo: to.topAnchor,constant: -width / 2).isActive = true
        self.image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.image.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -imageInset * 2).isActive = true
        self.image.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -imageInset * 2).isActive = true
    }
   

    
    func createPlanLockConstraints(to: UIView) {
        if blur != nil { // Удаляется, чтобы в момент изменения темы, блюр поменял цвет.
            blur.removeFromSuperview()
        }
        blur = UIVisualEffectView(effect: UIBlurEffect(style: Themer.shared.theme == .light
                                                       ? .systemThinMaterialLight
                                                       : .systemThinMaterialDark ))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.blur.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blur)
        self.addSubview(image)
        self.clipsToBounds = true // set cornerRadius to all view
        to.addSubview(self)
        let width = to.bounds.height / 2
        let imageInset: CGFloat = 8 // inset for image
        blur.frame = .zero
        
        
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: width).isActive = true
        self.centerXAnchor.constraint(equalTo: to.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: to.centerYAnchor).isActive = true
      
        blur.widthAnchor.constraint(equalToConstant: width).isActive = true
        blur.heightAnchor.constraint(equalToConstant: width).isActive = true
        blur.centerXAnchor.constraint(equalTo: to.centerXAnchor).isActive = true
        blur.centerYAnchor.constraint(equalTo: to.centerYAnchor).isActive = true

        self.image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.image.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -imageInset * 2).isActive = true
        self.image.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -imageInset * 2).isActive = true
    }
    

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.colors.loadColors()
        
      
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension LockView {
    func theme(_ theme: MyTheme) {
        image.setImageColor(color: theme.settings.titleTextColor)
        self.backgroundColor = theme.settings.borderColor
        
    }
}
