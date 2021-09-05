//
//  AddCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 19.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var accountImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //print(imageView.image)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
