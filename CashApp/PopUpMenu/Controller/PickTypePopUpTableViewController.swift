//
//  PickTypePopUpViewController.swift
//  CashApp
//
//  Created by Артур on 16.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class PickTypePopUpTableViewController: UITableViewController{
    
    
    
    var delegate: dismissVC!
    var cellNames = [String]()
    var goingTo: String = ""

 
    deinit {
        
    }
    @IBAction func goToAddVC(_ sender: UIButton) {
    
        switch goingTo {
        case "addCategoryVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addCategoryVC", typeIdentifier: sender.restorationIdentifier!)
        case "addScheduleVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addScheduleVC", typeIdentifier: sender.restorationIdentifier!)
        default:
            break
        } 
    }
    
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(true, animated: animated)
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        guard let navigationController = self.navigationController else {return}
        setupNavigationController(Navigation: navigationController)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        isModalInPresentation = false
        blurView.frame = self.view.bounds
        //self.view.addSubview(blurView)
        //self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        //blurView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PickTypeCell")
    }
 


    @IBAction func unwindSegueToPickTypeVC(_ segue: UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickTypeCell", for: indexPath)
        let object = cellNames[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.textLabel?.text = object
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = cellNames[indexPath.row]
        print(object)
        switch goingTo {
        case "addCategoryVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addCategoryVC", typeIdentifier: object)
        case "addScheduleVC" :
            dismiss(animated: true, completion: nil)
            delegate.dismissVC(goingTo: "addScheduleVC", typeIdentifier: object)
        default:
            break
        }
        
    }
}
