//
//  WithoutAccountTableViewCell.swift
//  CashApp
//
//  Created by Артур on 13.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class WithoutAccountTableViewCell: CellWithCustomSelect {
  //let colors = AppColors()
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        colors.loadColors()
        self.contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    func configureBackgroundView() {
        self.contentView.layer.setSmallShadow(color: colors.shadowColor)
        self.contentView.frame = self.contentView.bounds.inset(by: UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26) )
        self.contentView.layer.cornerRadius = 20
        self.backgroundColor = .clear
        self.contentView.backgroundColor = colors.secondaryBackgroundColor
        self.label.textColor = colors.titleTextColor
        self.layer.masksToBounds = false
        initConstraints(view: self.label, to: self.contentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureBackgroundView()
    }
    func createBorderIfCellSelected(){
        self.contentView.layer.borderWidth = 1.5
        self.contentView.layer.borderColor = colors.borderColor.cgColor
    }
    func removeBorder() {
        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
    func setBorder(selected: Bool) {
        if selected == true {
            createBorderIfCellSelected()
        } else {
            removeBorder()
        }
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setBorder(selected: selected)
        
    }
}
