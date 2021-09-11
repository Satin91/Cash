//
//  SideMenuViewController.swift
//  CashApp
//
//  Created by Артур on 19.08.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    var sideMenuSwitch: UISwitch = {
       let sw = UISwitch()
        sw.onTintColor = ThemeManager2.currentTheme().contrastColor1
        sw.tintColor = ThemeManager2.currentTheme().titleTextColor
        sw.thumbTintColor = ThemeManager2.currentTheme().titleTextColor
        return sw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualSettings()
        setupTableView()
        
        // Do any additional setup after loading the view.
    }
    func visualSettings() {
        self.view.backgroundColor = ThemeManager2.currentTheme().backgroundColor
        self.headerView.backgroundColor = ThemeManager2.currentTheme().secondaryBackgroundColor
    }
    
    let tableViewItemsArray = ["Dark theme","Notifications"]
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SideMenuCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    
}
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
           // ThemeManager.applyTheme(theme: .white)
        }else{
          //  ThemeManager.applyTheme(theme: .dark)
        }
        
        self.reloadInputViews()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell",for: indexPath)
        let object = tableViewItemsArray[indexPath.row]
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = ThemeManager2.currentTheme().backgroundColor
        sideMenuSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 50) )
        cell.accessoryView = sideMenuSwitch
        cell.selectionStyle = .none
        cell.textLabel?.text = object
        cell.textLabel?.textColor = ThemeManager2.currentTheme().titleTextColor
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
class SideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresent: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {return}
        
        let containerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 0.7
        let finalHeight = toViewController.view.bounds.height
        if isPresent {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0  , width: finalWidth, height: finalHeight)
            
        }
        let transform = {
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        let identity = {
            fromViewController.view.transform = .identity
        }
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration) {
            self.isPresent ? transform() : identity()
        } completion: { _ in
            transitionContext.completeTransition(!isCancelled)
        }

    }
    
    
    
}
