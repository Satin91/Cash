//
//  SubscriptionTableViewCell.swift
//  CashApp
//
//  Created by Артур on 21.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

    
    let colors = AppColors()
    var stackView: UIStackView!
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = colors.titleTextColor
        label.textAlignment = .left
        label.text = "monthLabel"
        return label
    }()
    lazy var freeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = colors.subtitleTextColor
        label.text = NSLocalizedString("subscribe_free_label", comment: "")
        label.textAlignment = .left
        return label
    }()
    lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = colors.contrastColor1
        label.text = "-53%"
        
        return label
    }()
    
    lazy var economyLabelContainer: UIView = {
       let view = UIView()
        view.backgroundColor = colors.redColor
        view.frame = .zero
        view.layer.cornerRadius = 18
        view.layer.cornerCurve = .continuous
        return view
    }()
   
    lazy var economyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = colors.whiteColor
        label.textAlignment = .center
        label.text = "-34%"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        contentView.clipsToBounds = false
        colors.loadColors()
        setupStackView()
        setupContentView()
        setupConstraints()
        
        // Initialization code
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints             = false
        sumLabel.translatesAutoresizingMaskIntoConstraints              = false
        economyLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        economyLabel.translatesAutoresizingMaskIntoConstraints          = false
        let economyHeight: CGFloat = 34
        let economyWidth: CGFloat  = 80
        NSLayoutConstraint.activate([
            
            economyLabelContainer.widthAnchor.constraint(equalToConstant: economyWidth),
            economyLabelContainer.heightAnchor.constraint(equalToConstant: economyHeight),
            economyLabelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            economyLabelContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -economyHeight / 2),
            
            economyLabel.widthAnchor.constraint(equalToConstant: economyWidth),
            economyLabel.heightAnchor.constraint(equalToConstant: economyHeight),
            economyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            economyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -economyHeight / 2),
            
     
            
            sumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            sumLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: sumLabel.leadingAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    func setupStackView() {
        stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = .leading
        stackView.spacing   = 16

        stackView.addArrangedSubview(monthLabel)
        stackView.addArrangedSubview(freeLabel)
        
    }
    
    func setupContentView() {
        contentView.addSubview(economyLabelContainer)
        economyLabelContainer.addSubview(economyLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(sumLabel)
        
        contentView.layer.cornerCurve  = .continuous
        contentView.layer.cornerRadius = 22
        contentView.layer.setSmallShadow(color: colors.shadowColor)
        //contentView.frame = self.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) )
        contentView.backgroundColor = colors.secondaryBackgroundColor
    }
    override func layoutSubviews() {
        contentView.frame = self.bounds.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) )
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func set() {
        
    }
}
