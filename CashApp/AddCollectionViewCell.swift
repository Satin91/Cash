//
//  AddCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 19.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer

extension AddCollectionViewCell {
    private func theme(_ theme: MyTheme) {
        imageView.changePngColorTo(color: theme.settings.titleTextColor)
    }
}
class AddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var accountImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func set(image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        Themer.shared.register(target: self, action: AddCollectionViewCell.theme(_:))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
