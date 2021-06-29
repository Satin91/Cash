//
//  HeaderView.swift
//  CashApp
//
//  Created by Артур on 28.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

protocol prepareForMainViewControllers {
    func prepareFor(viewController: UIViewController)
}

final class HeaderView: UIView {

    let themeManager = ThemeManager.currentTheme()
    
    var delegate: prepareForMainViewControllers!
    var dateLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .clear
        label.text = "TEXT"
        label.font = .boldSystemFont(ofSize: 34)
        label.frame = .zero
        label.layer.opacity = 0
        return label
    }()
    
    var accountsButton: UIButton = {
       let button = UIButton()
        button.frame = .zero
        button.backgroundColor = .clear
        button.setTitle("Accounts", for: .normal)
        
        return button
    }()
    
    var todayBalanceButton: UIButton = {
        let button = UIButton()
        button.frame = .zero
        button.backgroundColor = .clear
        button.setTitle("Today Balance", for: .normal)
        
        return button
    }()
    let lineView: UIView = {
       let line = UIView()
        
       return line
        
    }()
   
    
    func initControls() {
        accountsButton.addTarget(self, action: #selector(prepareForAccounts), for: .touchUpInside)
        todayBalanceButton.addTarget(self, action: #selector(prepareForTodayBalance), for: .touchUpInside)
        
        addSubview(dateLabel)
        addSubview(accountsButton)
        addSubview(todayBalanceButton)
        addSubview(lineView)
    }
    func setColorTheme() {
        lineView.backgroundColor = themeManager.separatorColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 35
        self.layer.shadowOpacity = 0.20
        self.layer.shadowColor = themeManager.shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 15
        self.layer.masksToBounds = false
        
        
        
        initControls()
        setColorTheme()
        createConstraints()
        dateLabel.center = self.center
    }
    
    
    
    @objc func prepareForAccounts(){
        let accVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AccountsViewController") as! AccountsViewController
        delegate.prepareFor(viewController: accVC)
    }
    
    @objc func prepareForTodayBalance(){
        let accVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TodayBalanceViewController") as! TodayBalanceViewController
        delegate.prepareFor(viewController: accVC)
    }
    
    func showButtons() {
        UIView.animate(withDuration: 0.2) {
            if self.accountsButton.layer.opacity == 0,self.todayBalanceButton.layer.opacity == 0 {
                self.accountsButton.layer.opacity = 1
                self.todayBalanceButton.layer.opacity = 1
                self.lineView.layer.opacity = 1
                self.dateLabel.layer.opacity = 0
            }
        }
    }
    func HideButtons() {
        UIView.animate(withDuration: 0.2) {
            if self.accountsButton.layer.opacity == 1,self.todayBalanceButton.layer.opacity == 1 {
                self.accountsButton.layer.opacity = 0
                self.todayBalanceButton.layer.opacity = 0
                self.lineView.layer.opacity = 0
                self.dateLabel.layer.opacity = 1
            }
        }
    }
    
    
    
    func createConstraints() {
        //label
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        //Account button
        NSLayoutConstraint.activate([
            accountsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            accountsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountsButton.topAnchor.constraint(equalTo: topAnchor),
            accountsButton.heightAnchor.constraint(equalToConstant: 157)
        ])
        //TodayBalance button
        NSLayoutConstraint.activate([
            todayBalanceButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            todayBalanceButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            todayBalanceButton.topAnchor.constraint(equalTo: accountsButton.bottomAnchor),
            todayBalanceButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        //LineView
        NSLayoutConstraint.activate([
        lineView.bottomAnchor.constraint(equalTo: accountsButton.bottomAnchor,constant: 6),
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
        lineView.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        todayBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        accountsButton.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
extension UIView {
    
    var middleShadow: UIView {
     let view = UIView()
        view.layer.shadowOpacity = 0.14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 15
        return view
        
    }
    
}
