//
//  ViewController.swift
//  CashApp
//
//  Created by Артур on 7/26/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var headerTotalSumLabel: UILabel!
    @IBOutlet var freeLabel: UILabel!
    @IBOutlet var freeSumLabel: UILabel!
    
    @IBOutlet var totalBalanceOutletButton: UIButton!
    @IBOutlet var schedulerOutletButton: UIButton!
    @IBOutlet var operationOutletButton: UIButton!
        
    @IBOutlet var historyTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setColorsForText(text: [headerLabel,freeLabel,freeSumLabel,headerTotalSumLabel,totalBalanceOutletButton.titleLabel!,schedulerOutletButton.titleLabel!,operationOutletButton.titleLabel!])
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //  navigationItem.title = todayDateToString(date: someDateOfComponents!)
 
        setLabelShadows()
        navigationItem.setValue("March, 13", forKey: "title")
        navigationController!.navigationBar.tintColor = whiteThemeMainText // не работае почему то
        
        setupNavigationController(Navigation: navigationController!)
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 26)!]
        //DBManager.addObject(object: realmObjectsToSave)
        
       
    }
    
    func setLabelShadows() {
        for i in [operationOutletButton.titleLabel!, schedulerOutletButton.titleLabel!, totalBalanceOutletButton.titleLabel!] {
            setCustomShadow(label: i, color: whiteThemeShadowText.cgColor, radius: 1, opacity: 0.3, size: CGSize(width: 1, height: 1))
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyObjects.count
    }
    
    //                        ROW ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.historyIdentifier, for: indexPath) as! TableViewCell
        let object = historyObjects[indexPath.row]
        cell.set(object: object)
        cell.setCellColor(cell: cell)
        
        
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
        

        for a in EnumeratedSequence(array: accountsObjects){
            if a.name == object.name {
                try! realm.write {
                    a.sum -= object.sum
                   
                    realm.add(a, update: .all)
            }
        }
        }
        
        for i in EnumeratedSequence(array: [operationSpendingObjects]){
            if i.name == object.name {
                try! realm.write {
                    i.sum -= object.sum
                   
                    realm.add(i, update: .all)
            }
               
            }
            
        }
        
        //                  DELETE ACTION
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in

            DBManager.removeObject(Object: object) // Метод удаляет файлы из базы данных
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

