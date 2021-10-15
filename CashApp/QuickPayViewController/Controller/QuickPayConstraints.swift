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
        numpadView.view.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        let sideLayout: CGFloat = 20
        let navBarHeight = navigationController!.navigationBar.frame.height
        let heightConstraintForCancelButton = (navBarHeight - cancelButton.bounds.height) / 2
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor ,constant: 0),
            containerView.bottomAnchor.constraint(equalTo: numpadView.view.topAnchor,constant: 0),
            containerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - (26 * 2)),
            containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: self.view.bounds.width + 26),
            
            payObjectNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            payObjectNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            payObjectNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            
            accountLabel.leadingAnchor.constraint(equalTo: payObjectNameLabel.leadingAnchor),
            accountLabel.topAnchor.constraint(equalTo: payObjectNameLabel.bottomAnchor, constant: 16),
            
            dateLabel.leadingAnchor.constraint(equalTo: payObjectNameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            
            convertedSumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideLayout),
            convertedSumLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideLayout),
            convertedSumLabel.bottomAnchor.constraint(equalTo: sumTextField.topAnchor, constant: -8),

            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: heightConstraintForCancelButton),
            cancelButton.widthAnchor.constraint(equalToConstant: 120 ),
           
            sumTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideLayout),
            sumTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideLayout),
            sumTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -sideLayout),

            numpadView.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            numpadView.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            numpadView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            numpadView.view.heightAnchor.constraint(equalTo: numpadView.view.widthAnchor),
        ])
    }
}
