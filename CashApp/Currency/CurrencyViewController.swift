//
//  AddCurrencyViewController.swift
//  CashApp
//
//  Created by Артур on 4.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

enum ActionsWithCurrency: String {
    case add = "Add"
    case edit = "Edit"
}
class CurrencyViewController: UIViewController {
    
    
    
    @IBOutlet var currencyConverterLabel: UILabel!
    @IBOutlet var currencyConverterTextField: NumberTextField!
    @IBOutlet var tableView: UITableView!
    @IBAction func addButton(_ sender: Any) {
        guard currencyObjects.isEmpty == false else{return}
        openTableViewController(action: .add)
        //self.navigationController?.pushViewController(navController, animated: true)
        //self.navigationController?.present(addCurrencyVC, animated: true, completion: nil)
        // self.navigationController?.pushViewController(addCurrencyVC, animated: true)
        
        //self.present(addCurrencyVC, animated: true, completion: nil)
        
    }
    func openTableViewController(action: ActionsWithCurrency) {
        let addCurrencyVC = AddCurrencyTableViewController()
        let navController = UINavigationController(rootViewController: addCurrencyVC)
        addCurrencyVC.modalTransitionStyle = .coverVertical
        addCurrencyVC.tableViewReloadDelegate = self
        addCurrencyVC.actionWithCurrency = action
        if action == .edit {
            for i in userCurrencyObjects {
                if i.ISO == mainCurrency!.ISO {
                    addCurrencyVC.mainCurrency = i
                }
            }
        }
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrenciesByPriorities()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.2 // optional
        tableView.addGestureRecognizer(longPress)
        tabBarController?.tabBar.hideTabBar()
        
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "currencyCell")
        tableViewSettings()
        currencyConverterTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        //tableView.isEditing = true
    }
    @objc func textFieldDidChange() {
        tableView.reloadData()
    }
    
    func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    
    
    // MARK: cell reorder / long press
    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        let locationInView = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        let duration: TimeInterval = 0.4
        let usingSpringWithDampingInterval: CGFloat = 0.6
        let initialSpringVelocityInterval: CGFloat = 0.1
        if sender.state == .began {
            if indexPath != nil {
                self.dragInitialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!)
                self.dragCellSnapshot = snapshotOfCell(inputView: cell!)
                var center = cell?.center
                dragCellSnapshot?.center = center!
                dragCellSnapshot?.alpha = 1.0
                cell?.alpha = 0
                cell?.isHidden = true
                tableView.addSubview(dragCellSnapshot!)
                //Прикольная анимация, убрать если не подойдет по дизайну
                UIView.animate(withDuration: duration,delay: 0, usingSpringWithDamping: usingSpringWithDampingInterval, initialSpringVelocity: initialSpringVelocityInterval ,options: .curveLinear,  animations: { () -> Void in
                    center?.y = locationInView.y
                    self.dragCellSnapshot?.center = center!
                    self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                    self.dragCellSnapshot?.alpha = 0.99
                }, completion: { (finished) -> Void in
                    if finished {
                        cell?.isHidden = true
                    }else{
                        UIView.animate(withDuration: duration, animations: { () -> Void in
                            self.dragCellSnapshot?.center = (cell?.center)!
                            self.dragCellSnapshot?.transform = CGAffineTransform.identity
                        }, completion: { (finishedForReserved) -> Void in
                            if finishedForReserved {
                                cell?.alpha = 1.0
                                cell?.isHidden = false
                                self.dragInitialIndexPath = nil
                                self.dragCellSnapshot?.removeFromSuperview()
                                self.dragCellSnapshot = nil
                            }
                        })
                    }
                })
            }
        } else if sender.state == .changed && dragInitialIndexPath != nil {
            var center = dragCellSnapshot?.center
            center?.y = locationInView.y
            dragCellSnapshot?.center = center!
            
            
            // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
            if indexPath != nil && indexPath != dragInitialIndexPath {
                // update your data model
                //  currencyPrioritiesObjects
                let dataToMove = userCurrencyObjects[dragInitialIndexPath!.row]
                //ресортировка массива помогает в дальнейшем определить приоритет после перемещения
                userCurrencyObjects.remove(at: dragInitialIndexPath!.row)
                userCurrencyObjects.insert(dataToMove, at: indexPath!.row)
                tableView.moveRow(at: dragInitialIndexPath!, to: indexPath!)
                
                dragInitialIndexPath = indexPath
            }
        } else if sender.state == .ended && dragInitialIndexPath != nil {
            
            let cell = tableView.cellForRow(at: dragInitialIndexPath!)
            cell?.isHidden = true
            //cell?.alpha = 1.0
            UIView.animate(withDuration: duration,delay: 0, usingSpringWithDamping: usingSpringWithDampingInterval , initialSpringVelocity: initialSpringVelocityInterval ,options: .curveEaseOut,  animations: { () -> Void in
                self.dragCellSnapshot?.center = (cell?.center)!
                self.dragCellSnapshot?.transform = CGAffineTransform.identity
                //self.dragCellSnapshot?.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    
                    self.changePriorityValue() //Функция для пересчета приоритета
                    cell?.alpha = 1.0
                    cell?.isHidden = false
                    self.dragInitialIndexPath = nil
                    self.dragCellSnapshot?.removeFromSuperview()
                    self.dragCellSnapshot = nil
                }else{
                    cell?.alpha = 1.0
                    cell?.isHidden = false
                }
            })
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let cellSnapshot = UIImageView(image: image)
        return cellSnapshot
    }
    
    
    
    func changePriorityValue() {
        for (index,value) in userCurrencyObjects.enumerated() {
            try! realm.write{
                value.ISOPriority = index
                realm.add(value,update: .all)
            }
        }
        tableView.reloadData()
    }
}

//MARK: TableView
extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    //Delete row by swipe
    func updateDataAfterRemove(indexPath: IndexPath) {
        
        for (index,value) in userCurrencyObjects.enumerated() {
            if index == indexPath.row {
                userCurrencyObjects.remove(at: indexPath.row)
                try! realm.write {
                    value.ISOPriority = 15888
                    realm.add(value,update: .all)
            }
                continue
        }
            for (index,value) in userCurrencyObjects.enumerated() {
                try! realm.write {
                value.ISOPriority = index
                    realm.add(value,update: .all)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCell.EditingStyle.insert) {
//        }
//
//        if (editingStyle == UITableViewCell.EditingStyle.delete) {
//            // delete data and row
//
//            updateDataAfterRemove(indexPath: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userCurrencyObjects.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let object = userCurrencyObjects[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.updateDataAfterRemove(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            
            self.openTableViewController(action: .edit)
        }
        guard object.ISO != mainCurrency!.ISO else {
            let actions = UISwipeActionsConfiguration(actions: [editAction])
            return actions
        }
        let actions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return actions
    }
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        let object = userCurrencyObjects[indexPath.row]
        
        if self.currencyConverterTextField.text?.isEmpty == false {
            cell.converterSet(currencyObject: object, enteredSum: Double(currencyConverterTextField.enteredSum)!)
        }else{
            cell.defaultSet(currencyObject: object)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}


class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet var currencyImage: UIImageView!
    @IBOutlet var ISOLabel: UILabel!
    @IBOutlet var currencyDescriptionLabel: UILabel!
    var mainCurrency: CurrencyObject? = {
        guard let object = userCurrencyObjects.first else {return nil}
        return object
    }()
    let currencyModelController = CurrencyModelController()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let object = userCurrencyObjects.first else {return}
        mainCurrency = object
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func defaultSet(currencyObject: CurrencyObject){
        getCurrenciesByPriorities()
        ISOLabel.text = currencyObject.ISO
        currencyDescriptionLabel.text = CurrencyName(rawValue: currencyObject.ISO)?.getRaw
    }
    
    func converterSet(currencyObject: CurrencyObject, enteredSum: Double){
        ISOLabel.text = currencyObject.ISO
        
        let convertedSum = currencyModelController.convert(enteredSum, inputCurrency: mainCurrency?.ISO, outputCurrency: currencyObject.ISO)?.formattedWithSeparator

        
        currencyDescriptionLabel.text = convertedSum
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds.inset(by: UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26))
    }
    
    func setupContentView() {
        self.contentView.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.cornerRadius = 20
        contentView.setShadow(view: self.contentView, size: CGSize(width: 0, height: 0), opacity: 0.3, radius: 20, color: UIColor.systemGray3.cgColor)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.backgroundColor = .white
        self.backgroundColor = .clear
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        setupContentView()
    }
    }
    


extension CurrencyViewController: ReloadParentTableView {
    func reloadData() {
        getCurrenciesByPriorities()
        tableView.reloadData()
    }
    
}

