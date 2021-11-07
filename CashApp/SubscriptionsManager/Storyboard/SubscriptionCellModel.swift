//
//  SubscriptionCellModel.swift
//  CashApp
//
//  Created by Артур on 6.11.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
class SubscriptionCellModel {
    var image: UIImage           = UIImage()
    var titleLabelName: String   = ""
    var descriptionLabel: String = ""
    init(image: UIImage, title: String, description: String) {
        self.image = image
        self.titleLabelName = title
        self.descriptionLabel = description
    }
}

