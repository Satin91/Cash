//
//  SelectSchedulerTypeViewController.swift
//  CashApp
//
//  Created by Артур on 6.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SelectSchedulerTypeViewController: UIViewController, closeScheduler {
    
    var reloadDelegate: ReloadParentTableView!
    func close() {
        self.reloadDelegate.reloadData()
        dismiss(animated: true)
    }
    
    
    @IBOutlet var heightBackgroundViewConstraint: NSLayoutConstraint!
    //labels
    @IBOutlet var oneTimeHeaderLabel: UILabel!
    @IBOutlet var oneTimeDescriptionLabel: UILabel!
    @IBOutlet var oneTimeContainer: UIView!
    
    @IBOutlet var multiplyHeaderLabel: UILabel!
    @IBOutlet var multiplyDescriptionLabel: UILabel!
    @IBOutlet var multiplyContainer: UIView!
    
    @IBOutlet var regularHeaderLabel: UILabel!
    @IBOutlet var regularDescriptionLabel: UILabel!
    @IBOutlet var regularContainer: UIView!
    
    @IBOutlet var goalHeaderLabel: UILabel!
    @IBOutlet var goalDescriptionLabel: UILabel!
    @IBOutlet var goalContainer: UIView!
    
    //Collections
    @IBOutlet var HeaderLabels: [UILabel]!
    // @IBOutlet var descriptionLabels: UILabel!
    
    @IBOutlet var containerView: [UIView]!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var descriptionLabels: [UILabel]!
    func visualSettings(){
        oneTimeHeaderLabel.text = "Целая сумма"
        oneTimeDescriptionLabel.text = "Создавайте долги, или любые другие платежи в рамках одной суммы."
        oneTimeContainer.tag = 1
        
        multiplyHeaderLabel.text = "Многоразовый платеж"
        multiplyDescriptionLabel.text = "Планируйте кредиты, рассрочки, указывайте интервалы платежей."
        multiplyContainer.tag = 2
        
        regularHeaderLabel.text = "Регулярный платеж"
        regularDescriptionLabel.text = "Создавайте платежи или выплаты на постоянной основе."
        regularContainer.tag = 3
        
        goalHeaderLabel.text = "Цель"
        goalDescriptionLabel.text = "Копите на что-нибудь? - Отлично! Укажите дату и сумму, а мы поможем Вам накопить."
        goalContainer.tag = 4
        
        for header in HeaderLabels {
            header.font = .systemFont(ofSize: 23, weight: .bold)
            header.textColor = ThemeManager.currentTheme().titleTextColor
        }
        for description in descriptionLabels {
            description.font = .systemFont(ofSize: 14, weight: .light)
            description.textColor = ThemeManager.currentTheme().subtitleTextColor
        }
        for container in containerView {
            
            container.layer.cornerRadius = 20
            container.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
            container.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        }
        
        self.backgroundView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.backgroundView.layer.cornerRadius = 22
        self.backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.roundedLine.frame = CGRect(x: 0, y: 22, width: 77, height: 8)
        self.roundedLine.layer.cornerRadius = 4
        self.roundedLine.center.x = self.backgroundView.center.x
    }
    var roundedLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.currentTheme().borderColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.addSubview(roundedLine)
        visualSettings()
        createTapGesture()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        // Do any additional setup after loading the view.
    }
    @objc func tapped(_ sender: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            for container in self.containerView {
                container.alpha = 0
            }
            
            self.roundedLine.alpha = 0
        }completion: { succes in
            if succes {
                UIView.animate(withDuration: 0.6 ,delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut ) {
                    self.backgroundView.layer.cornerRadius = 12
                    self.heightBackgroundViewConstraint.constant = self.view.bounds.height
                    self.view.layoutIfNeeded()
                }completion: { closeController in
                    self.addChildViewController(tag: sender.view!.tag)
                    
                }
                
            }
        }
    }
    func addChildViewController(tag: Int) {
        let addSchedulerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addScheduleVC") as! AddScheduleViewController
        let object = MonetaryScheduler()
        object.scheduleType = tag
        addSchedulerVC.newScheduleObject = object
        addSchedulerVC.view.frame = self.view.bounds
        addSchedulerVC.closeDelegate = self
        self.addChild(addSchedulerVC)
        self.view.addSubview(addSchedulerVC.view)
    }
    
    func createTapGesture(){
        let oneTimeTap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:) ))
        let multiplyTap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:) ))
        let regularTap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:) ))
        let goalTap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:) ))
        
        oneTimeContainer.addGestureRecognizer(oneTimeTap)
        multiplyContainer.addGestureRecognizer(multiplyTap)
        regularContainer.addGestureRecognizer(regularTap)
        goalContainer.addGestureRecognizer(goalTap)
    }
    
}
