//
//  AddCurrencyViewController.swift
//  CashApp
//
//  Created by Артур on 4.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import SwiftReorder

enum ActionsWithCurrency: String {
    case add = "Add"
    case edit = "Edit"
}
class CurrencyViewController: UIViewController {
    
    let currencyList = CurrencyList()
    @IBOutlet var currencyConverterLabel: UILabel!
    @IBOutlet var currencyConverterTextField: NumberTextField!
    @IBOutlet var tableView: UITableView!
    @IBAction func addButton(_ sender: Any) {
        guard currencyObjects.isEmpty == false else{return}
        openTableViewController(action: .add, object: nil)
        //self.navigationController?.pushViewController(navController, animated: true)
        //self.navigationController?.present(addCurrencyVC, animated: true, completion: nil)
        // self.navigationController?.pushViewController(addCurrencyVC, animated: true)
        
        //self.present(addCurrencyVC, animated: true, completion: nil)
        
    }
    func openTableViewController(action: ActionsWithCurrency, object: CurrencyObject?) {
        let addCurrencyVC = AddCurrencyTableViewController()
        let navController = UINavigationController(rootViewController: addCurrencyVC)
        addCurrencyVC.modalTransitionStyle = .coverVertical
        addCurrencyVC.tableViewReloadDelegate = self
        addCurrencyVC.actionWithCurrency = action
        if action == .edit {
            for i in userCurrencyObjects {
                if i.ISO == mainCurrency!.ISO {
                    addCurrencyVC.classCurrencyObject = i
                }
            }
        }
        addCurrencyVC.classCurrencyObject = object
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    var fetch = fetchMainCurrency() //Вызов для обновления валют
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
    func visualSettings() {
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        currencyConverterTextField.changeVisualDesigh()
        currencyConverterLabel.text = NSLocalizedString("currency_converter_label", comment: "")
        currencyConverterLabel.font = .systemFont(ofSize: 19, weight: .regular)
        currencyConverterLabel.textColor = ThemeManager.currentTheme().titleTextColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrenciesByPriorities()
        tabBarController?.tabBar.hideTabBar()
        visualSettings()
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "currencyCell")
        tableViewSettings()
        currencyConverterTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    @objc func textFieldDidChange() {
        tableView.reloadData()
    }
    
    func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reorder.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }

    func changePriorityValue() {
        for (index,value) in userCurrencyObjects.enumerated() {
            try! realm.write{
                value.ISOPriority = index
                realm.add(value,update: .all)
            }
        }
    }
}

//MARK: - TableView
extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource, TableViewReorderDelegate{

    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
//        let object = userCurrencyObjects[sourceIndexPath.row]
//        userCurrencyObjects.remove(at: sourceIndexPath.row)
//        userCurrencyObjects.insert(object, at: destinationIndexPath.row)
//        if destinationIndexPath.row == 1 {
//            tableView.reorder.autoScrollEnabled = false
//        }else {
//            tableView.reorder.autoScrollEnabled = true
//        }
        
       // self.changePriorityValue()
    }
    
    func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {
        
        let object = userCurrencyObjects[initialSourceIndexPath.row]
        userCurrencyObjects.remove(at: initialSourceIndexPath.row)
        userCurrencyObjects.insert(object, at: finalDestinationIndexPath.row)
        self.changePriorityValue()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //updateDataAfterRemove(indexPath: sourceIndexPath)
    }
   
    
    
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
        
        var edit = UIContextualAction()
        if object.ISO == mainCurrency?.ISO {
            edit = UIContextualAction(style: .normal, title: "Edit"){ _, _, _ in
                
            self.openTableViewController(action: .edit, object: object)
                tableView.isEditing = false
                
        }
        }else{
            edit = UIContextualAction(style: .normal, title: "Make main"){ _, _, complete in
                try! realm.write({
                    mainCurrency?.ISO = object.ISO
                    realm.add(mainCurrency!,update: .all)
                })
                
                complete(true)
             
                }
        }
        tableView.isEditing = false
        guard object.ISO != mainCurrency!.ISO else {
            let actions = UISwipeActionsConfiguration(actions: [edit])
            return actions
        }
        let actions = UISwipeActionsConfiguration(actions: [deleteAction, edit])
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
               return spacer
           }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        let object = userCurrencyObjects[indexPath.row]
        if self.currencyConverterTextField.text?.isEmpty == false {
            cell.converterSet(currencyObject: object, enteredSum: Double(currencyConverterTextField.enteredSum)!)
            cell.ISOLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
            cell.currencyImage.image = UIImage(named: object.ISO)
            cell.isMainCurrencyLabel.font = object.ISO == mainCurrency?.ISO ? .systemFont(ofSize: 17, weight: .medium) : .systemFont(ofSize: 17, weight: .regular)
            cell.isMainCurrencyLabel.text = object.ISO == mainCurrency?.ISO ? "Main cyrrency" : "Additional currency"
            cell.isMainCurrencyLabel.textColor = object.ISO == mainCurrency?.ISO ? ThemeManager.currentTheme().titleTextColor : ThemeManager.currentTheme().subtitleTextColor
            
            return cell
        }else{
            cell.defaultSet(currencyObject: object)
            cell.isMainCurrencyLabel.font = object.ISO == mainCurrency?.ISO ? .systemFont(ofSize: 17, weight: .medium) : .systemFont(ofSize: 17, weight: .regular)
            cell.isMainCurrencyLabel.text = object.ISO == mainCurrency?.ISO ? "Main cyrrency" : "Additional currency"
            cell.isMainCurrencyLabel.textColor = object.ISO == mainCurrency?.ISO ? ThemeManager.currentTheme().titleTextColor : ThemeManager.currentTheme().subtitleTextColor
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet var currencyImage: UIImageView!
    @IBOutlet var ISOLabel: UILabel!
    @IBOutlet var isMainCurrencyLabel: UILabel!
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
    
    func visualSettings() {
        ISOLabel.font = .systemFont(ofSize: 14, weight: .regular)
        isMainCurrencyLabel.font = .systemFont(ofSize: 17, weight: .regular)
        currencyDescriptionLabel.font = .systemFont(ofSize: 21, weight: .regular)
        ISOLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        isMainCurrencyLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        currencyDescriptionLabel.textColor = ThemeManager.currentTheme().titleTextColor
        currencyImage.layer.cornerRadius = 5
        currencyImage.layer.borderWidth = 1.5
        
        currencyImage.layer.borderColor = ThemeManager.currentTheme().backgroundColor.cgColor
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
   
    func defaultSet(currencyObject: CurrencyObject){
        getCurrenciesByPriorities()
        visualSettings()
        currencyImage.image = UIImage(named: currencyObject.ISO)
        isMainCurrencyLabel.text = currencyObject.ISO == mainCurrency?.ISO ? NSLocalizedString("main_currency_cell", comment: ""): NSLocalizedString("additional_currency_cell", comment: "")
        isMainCurrencyLabel.textColor = currencyObject.ISO == mainCurrency?.ISO ? ThemeManager.currentTheme().contrastColor1:ThemeManager.currentTheme().subtitleTextColor
        ISOLabel.text = currencyObject.ISO
        currencyDescriptionLabel.text = CurrencyList.CurrencyName(rawValue: currencyObject.ISO)?.getRaw
        print()
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
        contentView.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        contentView.layer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
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

