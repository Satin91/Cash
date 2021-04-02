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
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var headerTotalSumLabel: UILabel!
    @IBOutlet var freeLabel: UILabel!
    @IBOutlet var freeSumLabel: UILabel!
    
   
        
    @IBOutlet var historyTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  navigationItem.title = todayDateToString(date: someDateOfComponents!)
        
       
//        historyTableView.estimatedRowHeight = 500
//        historyTableView.rowHeight = UITableView.automaticDimension
        
        navigationItem.setValue("March, 13", forKey: "title")
        navigationController!.navigationBar.tintColor = whiteThemeMainText // не работае почему то, потому ято наверно стоит следом функция
      
        setupNavigationController(Navigation: navigationController!)
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 26)!]
        //DBManager.addAccountObject(object: accountObjectsToSave)
        self.view.backgroundColor = whiteThemeBackground
       
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
 
       return 45
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var visibleFirstIndex = historyTableView.indexPathsForVisibleRows?[0]
//        guard let index = visibleFirstIndex else {return}
//        historyTableView.beginUpdates()
//        let cell = historyTableView.dequeueReusableCell(withIdentifier: TableViewCell.historyIdentifier, for: index) as! TableViewCell
//        cell.contentView.layer.opacity = 0.4
//        historyTableView.reloadData()
//        print(historyTableView.indexPathsForVisibleRows![0])
//        print(scrollView.contentOffset.y)
//        historyTableView.endUpdates()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //tableView.beginUpdates()
        
        //tableView.endUpdates()
        
    }
    //                        ROW ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.historyIdentifier, for: indexPath) as! TableViewCell
        //let object = historyObjects[indexPath.row]
        let object2 = historyObjects[indexPath.row]
        //cell.headerLabel.text = object2.name
        cell.set(object: object2)
//        cell.setCellColor(cell: cell)
//        cell.sumLabel.text = String(object2.sum.currencyFR)
        cell.backgroundColor = .clear
        if let image = object2.image {
            cell.userImage.image = UIImage(named: image)
        }
        //cell.selectionStyle = .none
        
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
        
        //Арифметическая функция для вычитания суммы удаляемого объекта
        for a in EnumeratedAccounts(array: accountsObjects){
            if a.accountID == object.accountIdentifier {
                try! realm.write {
                    a.balance += object.sum   // Так как со счетов в историю всегда идут траты, тут +=
                    realm.add(a, update: .all)
            }
        }
        }
        
        
        //Методы для изменения суммы в категориях
        for i in EnumeratedSequence(array: paymentObjects){
            if object.entityIdentifier == i.monetaryID {
                let localSum = object.sum > 0 ? 0 - object.sum :  object.sum // Небольшое условия для локального отражения числа
               
                
                try! realm.write {
                    
                    i.sum += localSum
                    realm.add(i, update: .all)
            }

            }
        }

        for i in EnumeratedSequence(array: operationScheduler){
            if  object.entityIdentifier == i.monetaryID {
                try! realm.write {
                    i.sum -= object.sum
                    realm.add(i, update: .all)
            }

            }
        }
        
        
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
        
        //guard let newPayment = segue.source as? OperationViewController else { return }
        historyTableView.reloadData()
    }
  
    
}

