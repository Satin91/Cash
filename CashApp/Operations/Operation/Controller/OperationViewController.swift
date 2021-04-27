//
//  OperationViewController.swift
//  CashApp
//
//  Created by Артур on 9/10/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift



class OperationViewController: UIViewController, UITextFieldDelegate, dismissVC {
    
    
  
    
    func dismissVC(goingTo: String, restorationIdentifier: String) { // Вызывается после подтверждения выбора в addVc
   
        let addCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addCategoryVC") as! AddOperationViewController
        if goingTo == "addCategoryVC" {
            switch restorationIdentifier {
            case "first":
                addCategoryVC.newCategoryObject.stringEntityType = .income
            case "second":
                addCategoryVC.newCategoryObject.stringEntityType = .expence
            default:
                return
            }
        }
        addCategoryVC.tableReloadDelegate = self
        let navVC = UINavigationController(rootViewController: addCategoryVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true, completion: nil)
    }
    

    var popViewController: UIViewController! // Child View Controller
    var changeValue = true
    ///             Outlets:
    @IBOutlet var segmentedControl: HBSegmentedControl!
    @IBOutlet var operationTableView: UITableView!
    
    ///            Actions:
    @IBAction func actionSegmentedControl(_ sender: HBSegmentedControl) {
        changeSegmentAnimation(TableView: operationTableView, ChangeValue: &changeValue)
    }
    ///             POPUP VIEW
    @IBOutlet var blurView: UIVisualEffectView!
    ///             ACTIONS
    

    @IBAction func addButton(_ sender: Any) {
        //addVC
        let pickTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpViewController
        pickTypeVC.buttonsNames = ["Income","Expence"]
        pickTypeVC.goingTo = "addCategoryVC"
        pickTypeVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: pickTypeVC)
        navVC.modalPresentationStyle = .popover
        let popVC = navVC.popoverPresentationController
        popVC?.delegate = self
        let barButtonView = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
        popVC?.sourceView = barButtonView
        popVC?.sourceRect = barButtonView!.bounds
        pickTypeVC.preferredContentSize = CGSize(width: 200, height: 150)
        present(navVC, animated: true, completion: nil)
        // Передача данных описана в классе PickTypePopUpViewController
        guard popViewController != nil else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
            self.closeChildViewController()
        })
    }

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        operationTableView.reloadData()
        self.tabBarController?.tabBar.showTabBar()
        print("operationview did appear operationVC")
        //При переходе через таб бар обновления не происходят
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.changeValuesForCashApp(segmentOne: "Expence", segmentTwo: "Income")
        setupNavigationController(Navigation: navigationController!)
        blurView.bounds = self.view.frame
        self.view.backgroundColor = whiteThemeBackground
        let cellNib = UINib(nibName: "MainTableViewCell", bundle: nil)
        operationTableView.register(cellNib, forCellReuseIdentifier: "MainIdentifier")
        operationTableView.delegate = self
        operationTableView.dataSource = self
        operationTableView.separatorStyle = .none
        operationTableView.backgroundColor = .clear
    }
    
    //wait for Figma 
    func classColor() {
        self.view.backgroundColor = whiteThemeBackground
    }
    
 
 
    //MARK: Add/Delete Child View Controller
    func addChildViewController(PayObject: MonetaryCategory) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let QuiclPayVC = storyboard.instantiateViewController(withIdentifier: "QuickPayVC") as! QuickPayViewController
        QuiclPayVC.payObject = PayObject
        QuiclPayVC.closePopUpMenuDelegate = self //Почему то работает делегат только если кастить до popupviiewController'a
        // Проверка для того чтобы каждый раз не добавлять viewController при его открытии
     
        if popViewController == nil {
            popViewController = QuiclPayVC
            popViewController.view.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.55)
            popViewController.view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            self.addChild(popViewController) // Не знаю зачем это, надо удалить без него тоже работает
            self.view.animateViewWithBlur(animatedView: blurView, parentView: self.view)
            view.animateViewWithBlur(animatedView: popViewController.view, parentView: self.view)
            popViewController.didMove(toParent: self)
        }
    }
    
    func closeChildViewController() {
        self.view.reservedAnimateView(animatedView: popViewController.view, viewController: popViewController)
        popViewController = nil // Это нужно для того, чтобы снова его открыть. Потому что в открытии стоит условие
        self.view.reservedAnimateView(animatedView: blurView, viewController: nil)
        
    }
    
    
    @IBAction func unwindSegueToOperationVC(_ segue: UIStoryboardSegue){
       self.view.reservedAnimateView(animatedView: blurView, viewController: nil)
        operationTableView.reloadData()
    }
}










//MARK: TableView Delegate, DataSource
extension OperationViewController: UITableViewDelegate, UITableViewDataSource {
    ///                          TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        changeValue ? Array(expenceObjects).count : Array(incomeObjects).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainIdentifier", for: indexPath) as! MainTableViewCell
        
        switch changeValue {
        case true:
            let object = expenceObjects[indexPath.row]
            cell.set(monetaryObject: object)
        case false :
            let object = incomeObjects[indexPath.row]
            cell.set(monetaryObject: object)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        //Создание экземпляра
        let cell =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
        //Копирование экземпляра
//        let copyOfoperationEntity = MonetaryEntity()
//        copyOfoperationEntity.name = cell.name
//        copyOfoperationEntity.image = cell.image
//        let copyOfHistoryObject = AccountsHistory()
//        copyOfHistoryObject.name = cell.name
//        copyOfHistoryObject.image = cell.image
//        copyOfHistoryObject.entityIdentifier = cell.monetaryID
//
//        historyObject = copyOfHistoryObject
//        // presentationPopUpMenu()
        addChildViewController(PayObject: cell)
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        var object = MonetaryCategory()
        object = changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            DBManager.removeCategoryObject(Object: object) // Метод удаляет файлы из базы данных
            self.operationTableView.deleteRows(at: [indexPath], with: .middle) // метод удаляет ячейку
        }// Можно предложить пользователю удалить суму из operation tableView
        deleteAction.backgroundColor = whiteThemeRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
}

extension OperationViewController: ReloadTableView {
    func reloadTableView() {
        operationTableView.reloadData()
    }
}



extension OperationViewController: PopUpProtocol {
    
    func closePopUpMenu() {
        closeChildViewController()
        operationTableView.reloadData()
    }
}

extension OperationViewController: UIPopoverPresentationControllerDelegate{

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

