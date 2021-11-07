//
//  QuickPayConstraints.swift
//  CashApp
//
//  Created by Артур on 13.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension QuickPayViewController {
    
    func createConstraints() {
        convertedSumLabel.translatesAutoresizingMaskIntoConstraints      = false
        payObjectNameLabel.translatesAutoresizingMaskIntoConstraints     = false
        sumTextField.translatesAutoresizingMaskIntoConstraints           = false
        accountLabel.translatesAutoresizingMaskIntoConstraints           = false
        dateLabel.translatesAutoresizingMaskIntoConstraints              = false
        containerView.translatesAutoresizingMaskIntoConstraints          = false
        numpadView.view.translatesAutoresizingMaskIntoConstraints        = false
        cancelButton.translatesAutoresizingMaskIntoConstraints           = false
        currencyImage.translatesAutoresizingMaskIntoConstraints          = false
        transferPrimaryImage.translatesAutoresizingMaskIntoConstraints   = false
        transferSecondaryImage.translatesAutoresizingMaskIntoConstraints = false
        let sideLayout: CGFloat = 20
        let navBarHeight = navigationController!.navigationBar.frame.height
        let heightConstraintForCancelButton = (navBarHeight - cancelButton.bounds.height) / 2
        
        let isSE1Generation: Bool = self.view.bounds.height > 568 ? false : true
        
        
        var transferSize: CGFloat
        var sumTextFieldButtomAncher: CGFloat
        var currencyImageSize: CGFloat
        var convertedSumButtonAncher: CGFloat
        switch isSE1Generation {
        case true:
            
            transferSize = 14
            sumTextFieldButtomAncher = 8
            currencyImageSize = 28
            convertedSumButtonAncher = 4
            // Изменения сторонних свойств
            self.sumTextField.font      = .systemFont(ofSize: 34, weight: .regular)
            self.convertedSumLabel.font = .systemFont(ofSize: 18, weight: .regular)
            self.payObjectNameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        case false:
            
            transferSize = 22
            sumTextFieldButtomAncher = 20
            currencyImageSize = 34
            convertedSumButtonAncher = 8
        }
        
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor ,constant: 0),
            containerView.bottomAnchor.constraint(equalTo: numpadView.view.topAnchor,constant: 0),
            containerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - (26 * 2)),
            containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: self.view.bounds.width + 26),
            
            transferPrimaryImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            transferPrimaryImage.heightAnchor.constraint(equalToConstant: transferSize),
            transferPrimaryImage.widthAnchor.constraint(equalToConstant: transferSize),
            transferPrimaryImage.centerYAnchor.constraint(equalTo: payObjectNameLabel.centerYAnchor),
            
            payObjectNameLabel.leadingAnchor.constraint(equalTo: transferPrimaryImage.isHidden == true
                                                        ? containerView.leadingAnchor
                                                        : transferPrimaryImage.trailingAnchor),
            payObjectNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            payObjectNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            
           
            
            transferSecondaryImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            transferSecondaryImage.heightAnchor.constraint(equalToConstant: transferSize),
            transferSecondaryImage.widthAnchor.constraint(equalToConstant: transferSize),
            transferSecondaryImage.centerYAnchor.constraint(equalTo: accountLabel.centerYAnchor),
            
            accountLabel.leadingAnchor.constraint(equalTo: transferSecondaryImage.isHidden == true
                                                  ? containerView.leadingAnchor
                                                  : transferSecondaryImage.trailingAnchor),
            accountLabel.topAnchor.constraint(equalTo: payObjectNameLabel.bottomAnchor, constant: 16),
            
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            
            convertedSumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideLayout),
            convertedSumLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideLayout),
            convertedSumLabel.bottomAnchor.constraint(equalTo: sumTextField.topAnchor, constant: -convertedSumButtonAncher),

            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: heightConstraintForCancelButton),
            cancelButton.widthAnchor.constraint(equalToConstant: 120 ),
            
            currencyImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            currencyImage.widthAnchor.constraint(equalToConstant: currencyImageSize),
            currencyImage.heightAnchor.constraint(equalToConstant: currencyImageSize),
            currencyImage.centerYAnchor.constraint(equalTo: sumTextField.centerYAnchor),
            
            sumTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideLayout),
            sumTextField.leadingAnchor.constraint(equalTo: currencyImage.trailingAnchor),
            sumTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -sumTextFieldButtomAncher),
            
            numpadView.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            numpadView.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            numpadView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            numpadView.view.heightAnchor.constraint(equalTo: numpadView.view.widthAnchor),
        ])
     //   constraintsForSE1Generation()
        
    }
    
    func constraintsForSE1Generation() {
      
        
        
    }
}
