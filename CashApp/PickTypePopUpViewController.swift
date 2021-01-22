//
//  PickTypePopUpViewController.swift
//  CashApp
//
//  Created by Артур on 16.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class PickTypePopUpViewController: UIViewController {
    
    var buttonsNames = [String]()
    var goingTo: String = ""
    var entityLabelsNames = ["Add","approach","recurring fee","debt","spending"]
    var accountsLabelsNames = ["Add","card","cash","savings"]
    var bottomLabelText = ["to accounts","to schedule","category"]
    
    
    @IBAction func goToAddVC(_ sender: UIButton) {
        switch goingTo {
        case "addAccountVC" :
            goToAddAccountVC(restorationIdentifier: sender.restorationIdentifier!)
        case "addVC" :
            goToAddVC(restorationIdentifier: sender.restorationIdentifier!)
        default:
            break
        }
      
    }
    
    @IBOutlet var upperButton: UIButton!
    @IBOutlet var middleButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    @IBAction func bottomButton(_ sender: Any) {
    }
    @IBAction func gesture(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
  
    @IBOutlet var popUpView: UIView!
    
    @IBAction func pickGesture(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.navigationController else {return}
        setupNavigationController(Navigation: navigationController)
        buttonsName()
        isModalInPresentation = false
        popUpSettings()
    }
    func buttonsName(){
        upperButton.setTitle(buttonsNames[0], for: .normal)
        middleButton.setTitle(buttonsNames[1], for: .normal)
        bottomButton.setTitle(buttonsNames[2], for: .normal)
    }
    
    func goToAddAccountVC(restorationIdentifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addAccountVC = storyboard.instantiateViewController(identifier: "addAccountVC") as! AddAccountViewController
        let navVC = UINavigationController(rootViewController: addAccountVC)
        navVC.modalPresentationStyle = .pageSheet
        switch restorationIdentifier {
        case "upper":
            addAccountVC.newAccount.stringAccountType = .card
            addAccountVC.textForMiddleLabel = accountsLabelsNames[1]
        case "middle":
            addAccountVC.newAccount.stringAccountType = .cash
            addAccountVC.textForMiddleLabel = accountsLabelsNames[2]
        case "bottom":
            addAccountVC.newAccount.stringAccountType = .box
            addAccountVC.textForMiddleLabel = accountsLabelsNames[3]
        default:
            return
        }
        addAccountVC.textForUpperLabel = accountsLabelsNames[0]  // Здесь 0 для удобства т.к. модель начинается с единицы
        addAccountVC.textForBottomLabel = bottomLabelText[0]
       // addAccountVC.upperTextLabel.text = templateTextForLabelsNames["add"]!
        //addAccountVC.bottomTextLabel.text = templateTextForLabelsNames["to accounts"]
        present(navVC, animated: true)
    }
    
    func goToAddVC(restorationIdentifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(identifier: "addVC") as! AddSpendingViewController
        let navVC = UINavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = .pageSheet
        switch restorationIdentifier {
        case "upper":
            addVC.newEntityElement.stringEntityType = .approach
            addVC.textForMiddleLabel = entityLabelsNames[1]
        case "middle":
            addVC.newEntityElement.stringEntityType = .regular
            addVC.textForMiddleLabel = entityLabelsNames[2]
        case "bottom":
            addVC.textForMiddleLabel = entityLabelsNames[3]
            addVC.newEntityElement.stringEntityType = .debt
        default:
            return
        }
        addVC.textForUpperLabel = entityLabelsNames[0] // Здесь 0 для удобства т.к. модель начинается с единицы
        addVC.textForBottomLabel = bottomLabelText[1]
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
