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
        convertedSumLabel.translatesAutoresizingMaskIntoConstraints = false
        payObjectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        numpadView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor ,constant: 20),
            containerView.bottomAnchor.constraint(equalTo: numpadView.topAnchor,constant: 0),
            containerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - (26 * 2)),

            containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: self.view.bounds.width + 26),
            convertedSumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -26),
            convertedSumLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            convertedSumLabel.bottomAnchor.constraint(equalTo: sumTextField.topAnchor, constant: -8),

            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: self.cancelButton.bounds.width ),
           
            
            sumTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -26),
            sumTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            sumTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -26),
            
            payObjectNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            payObjectNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            
            accountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            accountLabel.topAnchor.constraint(equalTo: payObjectNameLabel.bottomAnchor, constant: 8),
            
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            dateLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            
            numpadView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            numpadView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            numpadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            numpadView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.45)
        ])
    }
}
