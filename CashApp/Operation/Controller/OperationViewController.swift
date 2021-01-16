//
//  OperationViewController.swift
//  CashApp
//
//  Created by Артур on 9/10/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift

class OperationViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, PopUpProtocol, DropDownProtocol{
    
    
    func dropDownAccountNameAndIndexPath(string: String, indexPath: Int) {
        
    }
    func dropDownAccountIdentifier(identifier: String) {
        historyObject.accountIdentifier = identifier  // Применил идентификатор от счета
    }
    
    
    
    var popViewController: UIViewController! // Child View Controller
    var operationEntity = MonetaryEntity()// Used in this class
    var historyObject = AccountsHistory()
    var changeValue = true
    ///             Outlets:
    @IBOutlet var segmentedControl: HBSegmentedControl!
    
    @IBOutlet var operationTableView: UITableView!
    
    @IBAction func actionSegmentedControl(_ sender: HBSegmentedControl) {
        changeSegmentAnimation(TableView: operationTableView, ChangeValue: &changeValue)
        
    }
    ///             POPUP VIEW
    @IBOutlet var blurView: UIVisualEffectView!
    ///             ACTIONS
    @IBAction func addButton(_ sender: Any) {
        //addVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch changeValue {
        case true:
            let addVC = storyboard.instantiateViewController(withIdentifier: "addVC") as! AddSpendingViewController
            addVC.newEntityElement.stringAccountType = .operationExpence
            addVC.middleText = "spending"
            addVC.bottomText = "category"
            self.navigationController?.pushViewController(addVC, animated: true)
        case false:
            let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUpVC") as! PickTypePopUpViewController
            let navVC = UINavigationController(rootViewController: popUpVC)
            navVC.modalPresentationStyle = .pageSheet
            //Передача данных описана в классе PickTypePopUpViewController
            present(navVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true // невозможность скрыть сдвигом вьюшку
        segmentedControl.changeValuesForCashApp(segmentOne: "Payment", segmentTwo: "Scheduler")
        setupNavigationController(Navigation: navigationController!)
        blurView.bounds = self.view.frame
        
    }
    func closePopUpMenu(touch: String, indexPath: Int?) {
        
        guard let operationIndexPath = operationTableView.indexPathForSelectedRow else {return}
        operationEntity.sum = Double(touch)! //ДОДЕЛАТЬ ОБЯЗАТЕЛЬНО !
        historyObject.sum = Double(touch)!
        historyObject.date = Date()
        if indexPath != nil {
            DBManager.updateAccount(accountType: EnumeratedSequence(array: accountsObjects), indexPath: indexPath!, addSum: Double(touch)!)
        }
        if touch != "0" { // В будущем при переводе в double тип изменить условие !
        DBManager.addHistoryObject(object: historyObject)
        }
        DBManager.updateObject(objectType: EnumeratedSequence(array: changeValue ? operationPayment: operationScheduler), indexPath: operationIndexPath.row, addSum: Double(touch)!) // Если что потом в operation Scheduler положить 'Box'
        
        closeChildViewController()
        operationTableView.reloadData()
        
    }
    
    
    
    //MARK: Add/Delete View Controller
    func addChildViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverVC = storyboard.instantiateViewController(withIdentifier: "payPopUpVC") as! PopUpViewController
        popoverVC.closePopUpMenuDelegate = self //Почему то работает делегат только если кастить до popupviiewController'a
        popoverVC.dropDownProtocol = self
        if popViewController == nil {
            // Проверка для того чтобы сто раз не добавлять viewController
            popViewController = popoverVC
            popViewController.view.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.4)
            popViewController.view.layer.cornerRadius = 25
            self.addChild(popViewController)
            self.view.animateView(animatedView: blurView, parentView: self.view)
            view.animateView(animatedView: popViewController.view, parentView: self.view)
            //view.addSubview(popViewController.view)
            popViewController.didMove(toParent: self)
        }
    }
    
    func closeChildViewController() {
        self.view.reservedAnimateView(animatedView: popViewController.view, viewController: popViewController)
        popViewController = nil // Это нужно для того, чтобы снова его открыть. Потому что в открытии стоит условие
        self.view.reservedAnimateView(animatedView: blurView, viewController: nil)
    }
    
    // Переход на экран добавления объекта
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddVC"{
            let addSpandingVC = segue.destination as! AddSpendingViewController
            addSpandingVC.changeValue = self.changeValue
        }
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
        changeValue ? EnumeratedSequence(array: operationPayment).count : EnumeratedSequence(array: operationScheduler).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.operationIdentifier, for: indexPath) as! TableViewCell
        switch changeValue {
        case true:
            let object = EnumeratedSequence(array: operationPayment)[indexPath.row]
            cell.set(object: object)
        case false :
            let object = EnumeratedSequence(array: operationScheduler)[indexPath.row]
            cell.set(object: object)
            cell.setSelected(false, animated: true)
        }
        cell.selectionStyle = .none
        cell.setCellColor(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        //Создание экземпляра
        let cell = EnumeratedSequence(array: changeValue ? operationPayment : operationScheduler)[indexPath.row]
        //Копирование экземпляра
        let copyOfoperationEntity = MonetaryEntity()
        copyOfoperationEntity.name = cell.name
        copyOfoperationEntity.image = cell.image
        let copyOfHistoryObject = AccountsHistory()
        copyOfHistoryObject.name = cell.name
        copyOfHistoryObject.image = cell.image
        operationEntity = copyOfoperationEntity
        historyObject = copyOfHistoryObject
        // presentationPopUpMenu()
        addChildViewController()
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        var object = MonetaryEntity()
        object = changeValue ? EnumeratedSequence(array: operationPayment)[indexPath.row] : EnumeratedSequence(array: operationScheduler)[indexPath.row]
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            DBManager.removeObject(Object: object) // Метод удаляет файлы из базы данных
            self.operationTableView.deleteRows(at: [indexPath], with: .middle) // метод удаляет ячейку
        }// Можно предложить пользователю удалить суму из operation tableView
        deleteAction.backgroundColor = whiteThemeRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
}

