//
//  OperationViewController.swift
//  CashApp
//
//  Created by Артур on 9/10/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift

class OperationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    
    var monetaryEntity = MonetaryEntity()
    
    
    var dropDownHeight = NSLayoutConstraint() //переменная для хранения значения констрейнта
    var dropDownIsOpen = false
    var changeValue = true
    
    ///             Outlets:
    @IBOutlet var segmentedControl: HBSegmentedControl!
    @IBOutlet var choseYouAccountLabel: UILabel!
    @IBOutlet var operationTableView: UITableView!
    var dropView = DropDownTableView()
    
    @IBAction func actionSegmentedControl(_ sender: HBSegmentedControl) {
        changeSegmentAnimation(TableView: operationTableView, ChangeValue: &changeValue)
        
    }
    
    ///             POPUP VIEW
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var gradientPopUpView: UIView!
    @IBOutlet var dropButtonView: GradientView!
    
    ///             TEXT FIELD
    @IBOutlet var popUpTextField: UITextField!
    
    ///             ACTIONS
    
    
    @IBAction func addButton(_ sender: Any) {
        
        //addVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch changeValue {
        case true:
            let addVC = storyboard.instantiateViewController(withIdentifier: "addVC") as! AddSpendingViewController
            //self.present(addVC, animated: true, completion: nil)
            addVC.newEntityElement.stringAccountType = .operationExpence
            addVC.middleText = "spending"
            addVC.bottomText = "category"
            self.navigationController?.pushViewController(addVC, animated: true)
            
        case false:
            let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUpVC") as! PickTypePopUpViewController
            let navVC = UINavigationController(rootViewController: popUpVC)
            navVC.modalPresentationStyle = .pageSheet
            
            
            present(navVC, animated: true, completion: nil)
            //present(navVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func dropMenuButton(_ sender: UIButton) {
        if dropDownIsOpen == false {
            dropDownIsOpen = true
            NSLayoutConstraint.deactivate([self.dropDownHeight])
            dropDownHeight.constant = popUpView.frame.height - dropButtonView.frame.height
            NSLayoutConstraint.activate([self.dropDownHeight])
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeLinear, animations: {
                
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
                self.choseYouAccountLabel.text = "Close"
            } )
            
        }else{
            dropDownIsOpen = false
            
            NSLayoutConstraint.deactivate([self.dropDownHeight])
            dropDownHeight.constant = 0
            NSLayoutConstraint.activate([self.dropDownHeight])
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeLinear, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
                self.choseYouAccountLabel.text = "Open"
            } )
            
        }
    }
    
    
    @IBAction func cancelBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPopUpButton(_ sender: Any) {
        popUpTextField.text = ""
        self.view.reservedAnimateView(animatedView: blurView)
        self.view.reservedAnimateView(animatedView: popUpView)
        
        // Метод unwind segue указан в сториборде.
    }
    dynamic var textField: String = "0"
    
    
    ///   Update object
    @IBAction func okPopUpAction(_ sender: Any) {
        guard let indexPath = operationTableView.indexPathForSelectedRow else {return}
        
        monetaryEntity.sum = Double(textField)! //
        DBManager.updateObject(objectType: EnumeratedSequence(array: changeValue ? operationPayment: operationScheduler), indexPath: indexPath.row, addSum: Double(textField)!)
        
        if textField != "0"{ DBManager.addObject(object: [monetaryEntity])
        }else {print("Не создастся")}
        popUpTextField.text = ""
        operationTableView.reloadData()
        self.view.reservedAnimateView(animatedView: blurView)
        self.view.reservedAnimateView(animatedView: popUpView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        registerForNotifications() //KeyboardShow
        whiteThemeFunc()
        popUpTextField.delegate = self
        
        //Весь код, выполненный для скрытия клавиатуры находится в классе KeyboardHedeManager
        isModalInPresentation = true // невозможность скрыть сдвигом вьюшку
        segmentedControl.changeValuesForCashApp(segmentOne: "Payment", segmentTwo: "Scheduler")
        
        setupNavigationController(Navigation: navigationController!)
        ///settings popUpMenu
        
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.4)
        blurView.bounds = self.view.frame
        popUpView.layer.cornerRadius = 18
        popUpTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        
        
        
    }
    
    
    
    //MARK:                 DropDownTableView
    
    func initDropDownTableView() {
        dropView = DropDownTableView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.addSubview(dropView)
        //Делает отображение поверх других вьюх
        popUpView.bringSubviewToFront(dropView)
        
        dropView.topAnchor.constraint(equalTo: dropButtonView.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: dropButtonView.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: dropButtonView.widthAnchor).isActive = true
        dropDownHeight = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        popUpTextField.resignFirstResponder()
        return false
    }
    
    
    func whiteThemeFunc() {
        choseYouAccountLabel.textColor = whiteThemeBackground
        popUpView.backgroundColor = whiteThemeBackground
    }
    
    // Переход на экран добавления объекта
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddVC"{
            
            let addSpandingVC = segue.destination as! AddSpendingViewController
            addSpandingVC.changeValue = self.changeValue
        }
    }
    
    @IBAction func unwindSegueToOperationVC(_ segue: UIStoryboardSegue){
        self.view.reservedAnimateView(animatedView: blurView)
        operationTableView.reloadData()
    }
    
    
    @objc private func textFieldChanged() {
        if popUpTextField.text?.isEmpty == false {
            self.textField = popUpTextField.text!    //// Функция для того чтобы текстфилд не вернул нил
        } else {
            self.textField = "0"
        }
        print(textField)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    ///                          TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        changeValue ? EnumeratedSequence(array: operationPayment).count : EnumeratedSequence(array: operationScheduler).count
    }
    
    //:MARK                       ROW SETTINGS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.operationIdentifier, for: indexPath) as! TableViewCell
        
        switch changeValue {
        case true:
            let object = EnumeratedSequence(array: operationPayment)[indexPath.row]
            cell.set(object: object)
        case false :
            let object = EnumeratedSequence(array: operationScheduler)[indexPath.row]
            cell.set(object: object)
            cell.userImage.image = UIImage(named: "carRepair")
            cell.setSelected(false, animated: true)
        }
        cell.selectionStyle = .none
        cell.setCellColor(cell: cell)
        
        return cell
    }
    
    //                      DID SELECT
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        //Создание экземпляра
        let cell = EnumeratedSequence(array: changeValue ? operationPayment : operationScheduler)[indexPath.row]
        //Копирование экземпляра
        let copyOfMonetaryEntity = MonetaryEntity(name: cell.name, sum: 0, userDescription: nil, date: Date(), image: cell.image, accountType: .history, userPerent: 0)
        //Получение пути индекса
        
        print("You selected cell #\(indexPath.row)!")
        view.animateView(animatedView: blurView, frame: self.view)
        view.animateView(animatedView: popUpView, frame: self.view)
        initDropDownTableView()
        
        monetaryEntity = copyOfMonetaryEntity
        
        
    }
    
    //                        DELETE ROW
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
    
    
    
    
    
    /// настройка появления клавиатуры
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForNotifications () {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        
        //Дело в том, что виличина непостоянная не принимается свифтом как уверенная и свифт постоянно прибавляет значения после
        //нажатия на textField. Frame непостоянная, bounds же всегда почемуто извнстна
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //нужно разобраться еще
        self.popUpView.frame.origin = CGPoint(x: self.popUpView.frame.origin.x, y: self.popUpView.bounds.origin.y + keyboardSize.height / 3)
    }
    
    @objc func kbWillHide (_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.popUpView.frame.origin = CGPoint(x: self.popUpView.frame.origin.x, y: self.popUpView.frame.origin.y + keyboardSize.height / 3 )
        
    }
    
}


