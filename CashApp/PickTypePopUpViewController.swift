//
//  PickTypePopUpViewController.swift
//  CashApp
//
//  Created by Артур on 16.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class PickTypePopUpViewController: UIViewController {
    
    @IBAction func goToAddVC(_ sender: UIButton) {
        goToAddVC(restorationIdentifier: sender.restorationIdentifier!)
    }
    
    @IBAction func gesture(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var popUpView: UIView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.navigationController else {return}
        setupNavigationController(Navigation: navigationController)
        isModalInPresentation = false
        popUpSettings()
    }
    
    func goToAddVC(restorationIdentifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(identifier: "addVC") as! AddSpendingViewController
        
        
        let navVC = UINavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = .pageSheet
        switch restorationIdentifier {
        case "approach":
            addVC.newEntityElement.stringAccountType = .approach
        case "debt":
            addVC.newEntityElement.stringAccountType = .debt
        case "recurring fee":
            addVC.newEntityElement.stringAccountType = .regular
        default:
            return
        }
        addVC.middleText = restorationIdentifier
        addVC.bottomText = "to schedule"
        present(navVC, animated: true)
    }
    
    @IBAction func unwindSegueToPickTypeVC(_ segue: UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func popUpSettings() {
        popUpView.backgroundColor = whiteThemeBackground
        popUpView.layer.cornerRadius = 16
        popUpView.setShadow(view: popUpView, size: CGSize(width: 8 , height: 8), opacity: 0.6, radius: 12, color: whiteThemeMainText.cgColor)
    }
    
    
}
