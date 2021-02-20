//
//  OperationViewController.swift
//  CashApp
//
//  Created by Артур on 9/10/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift

class OperationViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, PopUpProtocol, dismissVC{
    
   
    func dismissVC(goingTo: String, restorationIdentifier: String) { // Вызывается после подтверждения выбора в addVc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(identifier: "addVC") as! AddSpendingViewController
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
    
    var entityLabelsNames = ["Add","approach","recurring fee","debt","spending"]
    var bottomLabelText = ["to accounts","to schedule","category"]

    var popViewController: UIViewController! // Child View Controller
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
            addVC.newEntityElement.stringEntityType = .expence
            addVC.textForUpperLabel = "Add"
            addVC.textForMiddleLabel = "spending"
            addVC.textForBottomLabel = "category"
            self.navigationController?.pushViewController(addVC, animated: true)
        case false:
            let pickTypeVC = storyboard.instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpViewController
            pickTypeVC.buttonsNames = ["Approach","Recurring fee","Debt"]
            pickTypeVC.goingTo = "addVC"
            pickTypeVC.delegate = self
            let navVC = UINavigationController(rootViewController: pickTypeVC)
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
    
    func closePopUpMenu(enteredSum: Double, indexPath: Int?) {
//        guard let operationIndexPath = operationTableView.indexPathForSelectedRow else {return}
//        historyObject.sum = enteredSum
//        historyObject.date = Date()
//        if indexPath != nil { //Если счет не "Выбрать без счета"
//            DBManager.updateAccount(accountType: appendAccounts(object: accountsObjects), indexPath: indexPath!, addSum: enteredSum)
//        }
//        if enteredSum != 0 { // В будущем при переводе в double тип изменить условие !
//        DBManager.addHistoryObject(object: historyObject)
//        }
//        DBManager.updateObject(objectType: EnumeratedSequence(array: changeValue ? operationExpence: operationScheduler), indexPath: operationIndexPath.row, addSum: enteredSum) // Если что потом в operation Scheduler положить 'Box'
//        
        closeChildViewController()
        operationTableView.reloadData()
    }
 
    //MARK: Add/Delete Child View Controller
    func addChildViewController(PayObject: MonetaryEntity) {
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
            self.view.animateView(animatedView: blurView, parentView: self.view)
            view.animateView(animatedView: popViewController.view, parentView: self.view)
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
        changeValue ? EnumeratedSequence(array: operationExpence).count : EnumeratedSequence(array: operationScheduler).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.operationIdentifier, for: indexPath) as! TableViewCell
        switch changeValue {
        case true:
            let object = EnumeratedSequence(array: operationExpence)[indexPath.row]
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
        let cell = EnumeratedSequence(array: changeValue ? operationExpence : operationScheduler)[indexPath.row]
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
        
        
        var object = MonetaryEntity()
        object = changeValue ? EnumeratedSequence(array: operationExpence)[indexPath.row] : EnumeratedSequence(array: operationScheduler)[indexPath.row]
        
        
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

