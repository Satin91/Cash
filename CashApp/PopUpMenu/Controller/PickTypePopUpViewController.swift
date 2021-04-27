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
        
    }
    @IBAction func goToAddVC(_ sender: UIButton) {
    
        switch goingTo {
        case "addCategoryVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addCategoryVC", restorationIdentifier: sender.restorationIdentifier!)
        case "addScheduleVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addScheduleVC", restorationIdentifier: sender.restorationIdentifier!)
        default:
            break
        } 
    }
    
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(true, animated: animated)
      }
    
        
    @IBOutlet var firstButton: UIButton!
    
    @IBOutlet var secondbutton: UIButton!
    
    @IBAction func bottomButton(_ sender: Any) {
    }
    @IBAction func gesture(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func pickGesture(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.navigationController else {return}
        setupNavigationController(Navigation: navigationController)
        buttonsName()
        isModalInPresentation = false
        blurView.frame = self.view.bounds
        //self.view.addSubview(blurView)
        self.view.backgroundColor = .clear
        blurView.backgroundColor = .clear
        
        
        
    }
    func buttonsName(){
        firstButton.setTitle(buttonsNames[0], for: .normal)
        secondbutton.setTitle(buttonsNames[1], for: .normal)
       // bottomButton.setTitle(buttonsNames[2], for: .normal)
    }


    @IBAction func unwindSegueToPickTypeVC(_ segue: UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
    
 
    
    
}
