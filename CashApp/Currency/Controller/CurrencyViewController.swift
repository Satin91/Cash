//
//  CurrencyViewController.swift
//  CashApp
//
//  Created by Артур on 5.05.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {


    @IBOutlet var convertTextField: NumberTextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var resultLabel: UILabel!
  
    @IBAction func showResultButton(_ sender: Any) {
        resultLabel.text = selectedCurrency?.ISO
        //convertTextField.enteredSum
        resultLabel.text = currencyModelController.convert(convertTextField.enteredSum, inputCurrency: selectedCurrency?.ISO, outputCurrency: "USD")?.currencyFormatter(ISO: selectedCurrency?.ISO)
    }
    var selectedCurrency: CurrencyObject?
    var currencyModelController = CurrencyModelController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        currencyModelController.getCurrenciesFromJSON()
        print(currencyObjecs)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.showTabBar()
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "currencyCell")
        
    }
    func numberFormatter(number: NSNumber, identifier: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // formatter.locale = NSLocale.currentLocale() // This is the default
        // In Swift 4, this ^ was renamed to simply NSLocale.current
        var id = String()
       
        //let decimalsISO = ["SEK","NOK","CZK","JPY","HUF","IDR","ISK"]
        for i in curIdentifiers {
            if i.key == identifier {
                id = i.value.rawValue
                
            }
        }
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: id)
        
        return formatter.string(from: number)!
    }

}
extension CurrencyViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyObjecs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        let object = currencyObjecs[indexPath.row]
        cell.set(object: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = currencyObjecs[indexPath.row]
        selectedCurrency = object
    }
}

    
    

