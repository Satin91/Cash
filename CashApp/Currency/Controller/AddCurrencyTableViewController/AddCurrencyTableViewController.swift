//
//  AddCurrencyTableViewController.swift
//  CashApp
//
//  Created by Артур on 8.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer
class AddCurrencyTableViewController: UIViewController{
    
    let colors = AppColors()
    var actionWithCurrency: ActionsWithCurrency?
    var classCurrencyObject: CurrencyObject?
    private var filteredCurrencies: [CurrencyObject]?
    var searchController = UISearchController()
    var searchTextField: CurrencySearchBar!
    var tableView = UITableView()

    private var isFiltered: Bool = false
    
    var tableViewReloadDelegate: ReloadParentTableView?
    var navBar: UINavigationBar!
    var navBarView: UIVisualEffectView!
    var cancelButton: CancelButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.loadColors()
        self.setColors()
        title = ""
    //    navigationController?.navigationBar.backgroundColor = .black
        
        filteredCurrencies = currencyNonPrioritiesObjects
        setupTableView()
        //setupNavBar()
        createCustomNavBar()
        searchTextField = CurrencySearchBar(frame: .zero, cancelButton: self.cancelButton, navBar: self.navBarView.contentView)
        searchTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTextField.createLeftView() // Создается только в этм методе
    }
    func createCustomNavBar() {
        navBarView = UIVisualEffectView(effect: UIBlurEffect(style: Themer.shared.theme == .light ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark))
        navBarView.backgroundColor = .clear
        navBarView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60)
        cancelButton = CancelButton(frame: navBarView.bounds, title: .cancel, owner: self)
        cancelButton.addToNavBar(navBar: navBarView.contentView)
        self.view.addSubview(navBarView)
        let offset = self.navBarView.bounds.height
        self.tableView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -offset)
        
    }

   
 

    func createCancelButton() {
        let frame =  navigationController!.navigationBar.bounds
        cancelButton = CancelButton(frame: frame, title: .cancel, owner: self)
        cancelButton.addToNavBar(navBar: self.navBar)
    }

    func getNonPriorityISOArrayWithDescription() -> [String]{
        var objects: [String] = []
        for ISO in currencyNonPrioritiesObjects {
            let descript = CurrencyList.CurrencyName(rawValue: ISO.ISO)?.getRaw
            objects.append(descript! + " " + ISO.ISO)
        }
        return objects
    }
    
    
    func setupTableView() {
        self.view.addSubview(tableView)
        initConstraints(view: tableView, to: self.view)
        let nib = UINib(nibName: "AddCurrencyTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "addCurrencyCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView?.frame = tableView.tableHeaderView!.bounds.inset(by:  UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
    }
    
   
}

extension AddCurrencyTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        //Напоминалка: если оставить значение по умолчанию(0), То ничего(внезапно) не отобразится
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return filteredCurrencies!.count
        }else{
            return currencyNonPrioritiesObjects.count
        }
    }
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return searchController.searchBar
    //    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCurrencyCell", for: indexPath) as! AddCurrencyTableViewCell
        var object: CurrencyObject
        if isFiltered {
            object = filteredCurrencies![indexPath.row]
        }else{
            object = currencyNonPrioritiesObjects[indexPath.row]
        }
        cell.selectionStyle = .none
        cell.set(currencyObject: object)
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97 //10 это inset у контент вью
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var object: CurrencyObject?
        if isFiltered {
            object = filteredCurrencies![indexPath.row]
        }else{
            object = currencyNonPrioritiesObjects[indexPath.row]
        }
        if actionWithCurrency == .edit {
            let mainCurrency = fetchMainCurrency()
            
            try! realm.write {
                object!.ISOPriority = classCurrencyObject!.ISOPriority
                classCurrencyObject!.ISOPriority = 15888
                mainCurrency?.ISO = object!.ISO
                realm.add(classCurrencyObject!,update:.all)
                realm.add(mainCurrency!,update: .all)
            }
        }else if actionWithCurrency == .add {
            
            try! realm.write{
                if userCurrencyObjects.isEmpty == false {
                    object!.ISOPriority = userCurrencyObjects.last!.ISOPriority + 1
                }else{
                    //Если каким то образом (или вначале запуска приложения) отсутствует главная валюта
                    classCurrencyObject = object
                    classCurrencyObject!.ISOPriority = 0
                    self.classCurrencyObject?.ISO = object!.ISO
                    realm.add(self.classCurrencyObject!, update: .all)
                }
                
                realm.add(object!,update: .all)
            }
        }
        tableViewReloadDelegate?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddCurrencyTableViewController {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
        guard textField.text != "" else {
        isFiltered = false
            return }
        isFiltered = true
        filter(textField.text!)
    }
    
     func filter(_ searchText: String){
        
        let arrayWithDescription = getNonPriorityISOArrayWithDescription()
        // Получение массива из валют с их описанием
        let filter = arrayWithDescription.filter { object in
            let isContaining = object.lowercased().contains(searchText.lowercased())
            return isContaining
        }
        // Созданиие массива, который присвоит filteredCurrencies
        var ISOFArray: [CurrencyObject] = []
        // Поиск введенных букв по массиву невыбранных пользователем валют
        for i in filter {
            for x in currencyNonPrioritiesObjects {
                if i.suffix(3) == x.ISO {
                    ISOFArray.append(x)
                }
            }
        }
        // Присвоение отфильтрованного массива
        filteredCurrencies = ISOFArray
        tableView.reloadData()
    }
}

