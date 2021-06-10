//
//  ViewController.swift
//  CashApp
//
//  Created by Артур on 7/26/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift
import AAInfographics

class HomeViewController: UIViewController  {
    
    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    
    @IBOutlet var viewHistoryButton: UIButton!
    @IBOutlet var totalBalanceButtom: UIButton!
    @IBOutlet var historyTableView: EnlargeTableView!
    @IBOutlet var tableView: EnlargeTableView!
    var currencyModelController = CurrencyModelController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCurrenciesByPriorities()//Обновить данные об изменении главной валюты
        setTotalBalance() //Назначить сумму
        tableView.enterHistoryData() // Обновление данных истории
        tableView.reloadData()
            //При переходе через таб бар обновления не происходят
    }
   
    
    func setTotalBalance() {
        guard let validCurrency = currencyPrioritiesObjects.first else {return}
        var totalBalanceSum: Double = 0
        for i in accountsObjects {
            if i.currencyISO != validCurrency.ISO {
                totalBalanceSum += currencyModelController.convert(i.balance, inputCurrency: i.currencyISO, outputCurrency: validCurrency.ISO)!
            }else{
                totalBalanceSum += i.balance
            }
        }
        balanceLabel.text = String(totalBalanceSum.currencyFormatter(ISO: validCurrency.ISO))
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.clipsToBounds = true
        currencyModelController.getCurrenciesFromJSON()
        
        totalBalanceButtom.mainButtonTheme()
        setTotalBalance()
        tableView.separatorStyle = .none
        navigationItem.setValue("March, 13", forKey: "title")
        navigationController!.navigationBar.tintColor = whiteThemeMainText // не работае почему то, потому что наверно стоит следом функция
        setupNavigationController(Navigation: navigationController!)
        navigationItem.rightBarButtonItem?.title = "Currencies"
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 26)!]
        self.view.backgroundColor = .white
    }
   

    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyObjects.count
    }

 
    
    var selectedIndex = IndexPath()
    //нужно придумать как передавать индекс без нажатия
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
       return 76
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    //                        ROW ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainIdentifier", for: indexPath) as! MainTableViewCell
        //let object = historyObjects[indexPath.row]
        let object = historyObjects[indexPath.row]
        //cell.headerLabel.text = object2.name
     //   cell.set(object: object2)
//        cell.setCellColor(cell: cell)
//        cell.sumLabel.text = String(object2.sum.currencyFR)
        
        cell.set(monetaryObject: object)
        return cell
    }
    
    
    ///                        ANIMATE ROW
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * Double.pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
        cell.layer.transform = rotationTransform
        
         
        
        UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveEaseInOut, animations: {
            cell.layer.transform = CATransform3DIdentity
          
        })
        
        
    }
 
    
    
    //                        DELETE ROW
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let object = historyObjects[indexPath.row] // создание экземпляра
        
        for i in EnumeratedAccounts(array: accountsGroup){
            if object.accountID == i.accountID{
            try! realm.write{
                i.balance -= object.sum
                realm.add(i, update: .all)
            }
            }
        }
        //Арифметическая функция для вычитания суммы удаляемого объекта


        //Методы для изменения суммы в категориях
        for i in EnumeratedSequence(array: categoryGroup){
            if object.categoryID == i.categoryID {
                //let localSum = object.sum > 0 ? 0 - object.sum :  object.sum // Небольшое условия для локального отражения числа
                try! realm.write {
                    i.sum -= object.sum
                    realm.add(i, update: .all)
                }
            }
        }
        for i in payPerTimeObjects {
            if object.payPerTimeID == i.payPerTimeID{
            try! realm.write {
                i.target -= object.sum
                realm.add(i, update: .all)
            }
            }
        }
//        for i in EnumeratedSchedulers(object: schedulerGroup){
//            if  object.categoryID == i.scheduleID {
//                if i.stringScheduleType == .goal, i.stringScheduleType == .oneTime {
//                try! realm.write {
//                    i.available -= object.sum
//                    realm.add(i, update: .all)
//            }
//                }
//
//            }
//        }
        
        
        //                  DELETE ACTION
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in

            DBManager.removeHistoryObject(object: object) // Метод удаляет файлы из базы данных
            self.historyTableView.deleteRows(at: [indexPath], with: .middle) // метод удаляет ячейку
            
        }
        deleteAction.backgroundColor = whiteThemeRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false // Запрещает сразу удалить ячейку спомощью целого свайпа
        
        return configuration
        
    }
    
    
    //                    ANIMATE ROW
    

    @IBAction func unwindSegueToMainVC(_ segue: UIStoryboardSegue){
        historyTableView.reloadData()
        
    }
  
    
}

