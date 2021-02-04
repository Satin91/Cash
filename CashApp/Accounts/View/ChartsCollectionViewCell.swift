//
//  ChartsCollectionViewCell.swift
//  
//
//  Created by Артур on 4.02.21.
//

import UIKit

class ChartsCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "CollectionCell One"
        label.textColor = .gray
        return label
    }()
    static let identifier = "CollectionViewIdentifier"
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.frame = ChartsTableView.tableViewFrame
        //self.contentView.frame = ChartsTableView.tableViewFrame
        print(self.contentView)
       // self.frame = CGRect(x: 0, y: 0, width: 250, height: 400)
        self.backgroundColor = whiteThemeBackground
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 25)
        self.contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
