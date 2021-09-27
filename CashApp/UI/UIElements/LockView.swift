//
//  LockView.swift
//  CashApp
//
//  Created by Артур on 27.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

final class LockView: UIView {
let colors = AppColors()

    var image: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "subscribe.lock")
        return image
    }()
    
    func lock(_ isLock: Bool) {
        self.isHidden = !isLock
    }
    func addLock(to: UIView ,withRadius: CGFloat) {
        
        self.backgroundColor = .clear //colors.titleTextColor.withAlphaComponent(0.4)
        self.layer.cornerRadius = withRadius
        self.addSubview(self.image)
       
        self.image.frame = self.bounds
        self.image.contentMode = .center
        initConstraints(view: self.image, to: self)
        self.image.setImageColor(color: colors.contrastColor1)
        to.insertSubview(self, at: 20)
        
        initConstraints(view: self, to: to)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.colors.loadColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
