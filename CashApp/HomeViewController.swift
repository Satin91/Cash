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

func unique<S : Sequence, T : CurrencyObject>(source: S) -> [T] where S.Iterator.Element == T {
    var buffer = [T]()
    var added = Set<T>()
    
    
    for elem in source {
        if !added.contains(where: { object in
            object.ISO == elem.ISO
        }) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
}

class HomeViewController: UIViewController  {
    
    //label который сверху (бывш. Total balance)
    @IBOutlet var primaryLabel: UILabel!
    //собсна баланс
    @IBOutlet var balanceLabel: UILabel!
    //собсна кнопка для показывания счетов
    @IBOutlet var totalBalanceButtom: UIButton!
    @IBOutlet var tableView: EnlargeTableView!
    var currencyModelController = CurrencyModelController()
    var theme = ThemeManager.currentTheme()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCurrenciesByPriorities()//Обновить данные об изменении главной валюты
       // setTotalBalance() //Назначить сумму
        tableView.enterHistoryData() // Обновление данных истории
        tableView.reloadData()
         
    }   
    //MARK: SCROLL EFFECT

    
    
    @objc func changeSizeForHeightBgConstraint(notification: Notification) {
        let object = notification.object as! CGPoint
        
        let heightRange = 120...300
        let sideDistanceRange = 0...26
        let newobj = -object.y
        let sideDistance: CGFloat = 0.26
        let persent =  CGFloat(Int(newobj * 100) / heightRange.max()! )
        let sidePosition = sideDistance * persent
        if sideDistanceRange.contains(Int(sidePosition)) {
           
        }
        //backgroundView.bounds.size.height = newobj
        //let nvHeight = (navigationController?.navigationBar.bounds.height)! * 2
    }
    
    
   
   
    func visualSettings() {
        navigationItem.setValue("Home", forKey: "title")
        setupNavigationController(Navigation: navigationController!)
        navigationItem.rightBarButtonItem?.title = "Currencies"
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 26)!]
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
    
    }
    var header: HeaderView!
    func installBackgroundView() {
        header = HeaderView(frame:.zero)
        header.backgroundColor = .systemBackground
        header.delegate = self
        self.view.addSubview(header)
        
        tableView.header = header
        //top bar extension described in anyOption
        tableView.topBarHeight = topBarHeight
        
    }
    func getCurrencyCode() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        installBackgroundView()
        self.view.backgroundColor = theme.viewBackgroundColor
        //totalBalanceButtom.mainButtonTheme()
        tableView.clipsToBounds = true
        currencyModelController.getCurrenciesFromJSON()
       // setTotalBalance()
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSizeForHeightBgConstraint(notification: )), name: Notification.Name("TableViewOffsetChanged"), object: nil)
        
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
        }
        deleteAction.backgroundColor = whiteThemeRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false // Запрещает сразу удалить ячейку спомощью целого свайпа
        
        return configuration
        
    }

}

extension HomeViewController: prepareForMainViewControllers {
    func prepareFor(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
