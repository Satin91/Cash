//
//  AddCurrencyTableViewController.swift
//  CashApp
//
//  Created by Артур on 8.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddCurrencyTableViewController: UITableViewController{
    
  
    var actionWithCurrency: ActionsWithCurrency?
    var mainCurrency: CurrencyObject?
    private var filteredCurrencies: [CurrencyObject]?
    private var searchController = UISearchController()
    
    private var searchIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltered: Bool {
        return searchController.isActive && !searchIsEmpty
    }
    
    var tableViewReloadDelegate: ReloadParentTableView?
    
   
    func createSearchBar(){
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.font = .systemFont(ofSize: 17)
        searchController.searchBar.searchTextField.textAlignment = .center
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
       // searchController.searchBar.searchBarStyle = .prominent
        //searchController.searchBar.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        filteredCurrencies = currencyNonPrioritiesObjects
        
        createSearchBar()
        setupTableView()
    }
   
    
    func setupTableView() {
        let nib = UINib(nibName: "AddCurrencyTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "addCurrencyCell")
        tableView.tableFooterView = UIView()
    }
    // MARK: - Search bar delegate
 
  
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        //Напоминалка: если оставить значение по умолчанию(0), То ничего(внезапно) не отобразится
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return filteredCurrencies!.count
        }else{
            return currencyNonPrioritiesObjects.count
        }
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return searchController.searchBar
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCurrencyCell", for: indexPath) as! AddCurrencyTableViewCell
        var object: CurrencyObject
        if isFiltered {
            object = filteredCurrencies![indexPath.row]
        }else{
            object = currencyNonPrioritiesObjects[indexPath.row]
        }
        
        cell.set(currencyObject: object)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object: CurrencyObject
        
        if actionWithCurrency == .edit {
            try! realm.write {
                
                mainCurrency?.ISO = currencyNonPrioritiesObjects[indexPath.row].ISO
                realm.add(mainCurrency!,update: .all)
            }
        }
        
        if isFiltered {
            object = filteredCurrencies![indexPath.row]
        }else{
            object = currencyNonPrioritiesObjects[indexPath.row]
        }
        try! realm.write{
            if currencyPrioritiesObjects.isEmpty == false {
                object.ISOPriority = currencyPrioritiesObjects.last!.ISOPriority + 1
            }else{
                //Если каким то образом (или вначале запуска приложения) отсутствует главная валюта
                
                object.ISOPriority = 0
                mainCurrency?.ISO = object.ISO
                realm.add(mainCurrency!, update: .all)
            }
            
            realm.add(object,update: .all)
        }
        tableViewReloadDelegate?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddCurrencyTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_  searchText: String){
        var objectt = CurrencyObject(ISO: "EUR", exchangeRate: 1.2)
        filteredCurrencies = currencyNonPrioritiesObjects.filter({ (object: CurrencyObject) in
            return object.ISO.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
