//
//  SelectSchedulerTypeViewController.swift
//  CashApp
//
//  Created by Артур on 6.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer

extension SelectSchedulerTypeViewController {
    private func theme(_ theme: MyTheme) {
        self.backgroundView.backgroundColor = theme.settings.backgroundColor
        self.roundedLine.backgroundColor = theme.settings.borderColor
        labelsColors(headerColor: theme.settings.titleTextColor,
                     descriptionColor: theme.settings.subtitleTextColor,
                     containerColor: theme.settings.secondaryBackgroundColor,
                     shadowColor: theme.settings.shadowColor)
    }
    
}
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
    
    
    func labelsColors(headerColor: UIColor, descriptionColor: UIColor, containerColor: UIColor, shadowColor: UIColor) {
        for header in HeaderLabels {
            header.font = .systemFont(ofSize: 23, weight: .bold)
            header.textColor = headerColor
        }
        for description in descriptionLabels {
            description.font = .systemFont(ofSize: 14, weight: .light)
            description.textColor = descriptionColor
        }
        for container in containerView {
            container.layer.cornerRadius = 20
            container.backgroundColor = containerColor
            container.layer.setMiddleShadow(color: shadowColor)
        }
    }
    func visualSettings(){
        oneTimeHeaderLabel.text = NSLocalizedString("select_one_time_title", comment: "")
        oneTimeDescriptionLabel.text = NSLocalizedString("select_one_time_description", comment: "")
        oneTimeContainer.tag = 1
        
        multiplyHeaderLabel.text = NSLocalizedString("select_multiply_title", comment: "")
        multiplyDescriptionLabel.text = NSLocalizedString("select_multiply_description", comment: "")
        multiplyContainer.tag = 2
        
        regularHeaderLabel.text = NSLocalizedString("select_regular_title", comment: "")
        regularDescriptionLabel.text = NSLocalizedString("select_regular_description", comment: "")
        regularContainer.tag = 3
        
        goalHeaderLabel.text = NSLocalizedString("select_goal_title", comment: "")
        goalDescriptionLabel.text = NSLocalizedString("select_goal_description", comment: "")
        goalContainer.tag = 4
        
        
        
        self.backgroundView.layer.cornerRadius = 22
        self.backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.roundedLine.frame = CGRect(x: 0, y: 22, width: 77, height: 8)
        self.roundedLine.layer.cornerRadius = 4
        self.roundedLine.center.x = self.backgroundView.center.x
    }
    var roundedLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager2.currentTheme().borderColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Themer.shared.register(target: self, action: SelectSchedulerTypeViewController.theme(_:))
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
        
        let vc = UINavigationController(rootViewController: addSchedulerVC)
        let object = MonetaryScheduler()
        object.scheduleType = tag
        addSchedulerVC.newScheduleObject = object
        addSchedulerVC.view.frame = self.view.bounds
        addSchedulerVC.closeDelegate = self
        self.addChild(vc)
        self.isModalInPresentation = true
        self.view.addSubview(vc.view)
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
