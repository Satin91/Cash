//
//  SchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 2.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController, dismissVC {
    
    var entityLabelsNames = ["Add","approach","recurring fee","debt","spending"]
    var bottomLabelText = ["to accounts","to schedule","category"]

    
    func dismissVC(goingTo: String, restorationIdentifier: String) {
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addVC") as! AddOperationViewController
        
        if goingTo == "addVC"{
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
            let navVC = UINavigationController(rootViewController: addVC)
            navVC.modalPresentationStyle = .pageSheet
            addVC.textForUpperLabel = entityLabelsNames[0] // Здесь 0 для удобства т.к. модель начинается с единицы
            addVC.textForBottomLabel = bottomLabelText[1]
            present(navVC, animated: true)
       
        }
    }
    

    @IBAction func addButton(_ sender: Any) {
     
        let pickTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addVC") as! PickTypePopUpViewController
        
        pickTypeVC.buttonsNames = ["Approach","Recurring fee","Debt"]
        pickTypeVC.goingTo = "addVC"
        pickTypeVC.delegate = self
        let navVC = UINavigationController(rootViewController: pickTypeVC)
        navVC.modalPresentationStyle = .pageSheet
        
        //Передача данных описана в классе PickTypePopUpViewController
        present(navVC, animated: true, completion: nil)
        //Написать действие по созданию планировщика
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
