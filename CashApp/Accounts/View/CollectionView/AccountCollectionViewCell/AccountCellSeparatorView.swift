//
//  AccountCellSeparatorView.swift
//  CashApp
//
//  Created by Артур on 18.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AccountCellSeparatorView: UIView {
    let colors = AppColors()
    var gradientLayer: CAGradientLayer!
    var lineView: UIView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colors.loadColors()
        self.backgroundColor = colors.whiteColor.withAlphaComponent(0.25)
        self.lineView = UIView(frame: .zero)
        self.isUserInteractionEnabled = false
        self.lineView.isUserInteractionEnabled = false
        self.addSubview(lineView)
    }
    func createGradient(line: UIView){
        let rightColor = colors.whiteColor.withAlphaComponent(0.1)
        let leftColor = colors.whiteColor.withAlphaComponent(0.45)
         
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.type = .axial
        self.gradientLayer.colors = [rightColor.cgColor,leftColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer.endPoint = CGPoint (x: 0, y: 1)
       
        self.gradientLayer.frame = line.bounds
        line.layer.addSublayer(gradientLayer)
    }

    
    func constraintsForLineView() {
        
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.topAnchor.constraint(equalTo: self.topAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        createGradient(line: lineView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintsForLineView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
