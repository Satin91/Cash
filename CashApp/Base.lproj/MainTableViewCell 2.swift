//
//  MeinTableViewCell.swift
//  CashApp
//
//  Created by Артур on 7/30/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    ///Mein View outlets
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var pristoLenta: UIImageView!
    
    ///Accounts View outlets
    
    
    @IBOutlet var accNeomorphicCell: NeomorphicView!
    @IBOutlet var accType: UILabel!
    @IBOutlet var accName: UILabel!
    @IBOutlet var accSubTitle: UILabel!
    @IBOutlet var accSum: UILabel!
    @IBOutlet var accImage: UIImageView!
    ///operation View outlets
    class operationOutlets: MainTableViewCell {
        //@IBOutlet var operationImage: UIImageView!
        @IBOutlet var operationName: UILabel!
        @IBOutlet var operationTotalSum: UILabel!
        
        func operationSet(object: payment){
               let operationViewOutlets = operationOutlets()
               operationViewOutlets.operationName?.text = object.name
               //operationViewOutlets.operationImage?.image = object.image
               operationViewOutlets.operationTotalSum?.text =  separatedNumber(object.totalSum)
           }
    }
    
    
    
    ///Identifiers
    static let identifier = "mainHistoryCell"
    static let accIdentifier = "accIdentifier"
    static let operationTableViewCell = "operationTableViewCell"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    ///Main view history TableView
    func historySet(object: monetaryEntity) {
        self.headerLabel?.text = object.description
        self.descriptionLabel?.text = object.date
        self.sumLabel?.text = separatedNumber(object.sum)
        self.userImage?.image = object.image
    }
    
    ///Accounts View TableView
    func accSetCard(object: card){
        self.accType?.text = object.type
        self.accName?.text = object.name
        self.accSubTitle?.text = object.subtitle
        self.accSum?.text = separatedNumber(object.sum)
        self.accImage?.image = object.image
    }
    
    func accSetCash(object: cash){
        self.accType?.text = object.type
        self.accName?.text = object.name
        self.accSubTitle?.text = object.subtitle
        self.accSum?.text = separatedNumber(object.sum)
        self.accImage?.image = object.image
    }
    
    func accSetBox(object: box){
        self.accType?.text = object.type
        self.accName?.text = object.name
        self.accSubTitle?.text = String(object.percent)
        self.accSum?.text = separatedNumber(object.sum)
        self.accImage?.image = object.image
    }
    
    ///Scheduler View TableView
    func schSetIncome(object: income){
        self.accType?.text = object.type
        self.accName?.text = object.name
        self.accSubTitle?.text = object.date
        self.accSum?.text = separatedNumber(object.sum)
        self.accImage?.image = object.image
    }
    
    func schSetDept(object: dept){
        self.accType?.text = object.type
        self.accName?.text = object.name
        self.accSubTitle?.text = object.date
        self.accSum?.text = separatedNumber(object.sum)
        self.accImage?.image = object.image
    }
    func schSetRegular(object: regular){
        
        
        
        self.accType?.text = object.type
        self.accName?.text = object.name
        self.accSubTitle?.text = object.date
        self.accSum?.text = separatedNumber(object.sum)
        
        self.accImage?.image = object.image
    }
    
    
    ///Operation View TableView
   
}
//Создать единую функцию для передачи информации на аутлеты


///MoneyIcon
var currencySymbol = "$ "
///Formatter Func
func separatedNumber(_ number: Any) -> String {
    guard let itIsANumber = number as? NSNumber else { return "Not a number" }
    let formatter = NumberFormatter()
    formatter.currencySymbol = currencySymbol
    formatter.numberStyle = .currency
    formatter.currencyDecimalSeparator = ","
    formatter.currencyGroupingSeparator = " "
    
    
    
    
    
    return formatter.string(from: itIsANumber)!
}



//testLabel.text = separatedNumber(number) // выводит "1 234 567,89"
