//
//  PieChartTableViewCell.swift
//  CashApp
//
//  Created by Артур on 11.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//


import UIKit

class PieChartTableViewCell: UITableViewCell {

    
    var collectionView: PieChartCollectionViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView = PieChartCollectionViewController(collectionViewLayout: LineChartCollectionViewController.layout)
        collectionView.view.frame = self.bounds
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(collectionView.view)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
