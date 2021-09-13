//
//  AccountImageCell.swift
//  CashApp
//
//  Created by Артур on 5.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AccountImageCell: UICollectionViewCell {

    var accImage: UIImageView!
    override func awakeFromNib() {
        
        // Initialization code
    }
    func set(image: UIImage){
        accImage.image = image
    }
    func setTheBorder(view: UIImageView) {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //accImage.layer.borderColor = UIColor.clear.cgColor
        
    }
 
    override var isSelected: Bool {
        didSet {
          UIView.animate(withDuration: 0.3) {
            let scale: CGFloat = 1.05
              self.accImage.transform = self.accImage.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
          }
        }
    }
    

    
    func setupCell() {
        accImage = UIImageView(frame: self.bounds)
        self.contentView.addSubview(accImage)
        self.accImage.layer.cornerRadius = self.bounds.height / 6
        self.accImage.layer.cornerCurve = .continuous
        self.accImage.clipsToBounds = true
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.awakeFromNib()
        setupCell()
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }
    
}
