//
//  PickTypePopUpViewController.swift
//  CashApp
//
//  Created by Артур on 16.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class PickTypePopUpViewController: UIViewController{
    
    
    
    var delegate: dismissVC!
    var buttonsNames = [String]()
    var goingTo: String = ""

    
    deinit {
        print("PickTypePopUpViewController did closed")
    }
    @IBAction func goToAddVC(_ sender: UIButton) {
    
        switch goingTo {
        case "addAccountVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addAccountVC", restorationIdentifier: sender.restorationIdentifier!)
         
        case "addVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addVC", restorationIdentifier: sender.restorationIdentifier!)
           
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


    @IBAction func unwindSegueToPickTypeVC(_ segue: UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func popUpSettings() {
        popUpView.backgroundColor = whiteThemeBackground
        popUpView.layer.cornerRadius = 16
        popUpView.setShadow(view: popUpView, size: CGSize(width: 8 , height: 8), opacity: 0.6, radius: 12, color: whiteThemeMainText.cgColor)
    }
    
    
}
