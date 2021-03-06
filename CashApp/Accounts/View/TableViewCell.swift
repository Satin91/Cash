//
//  MeinTableViewCell.swift
//  CashApp
//
//  Created by Артур on 7/30/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    
    @IBOutlet var dropDownHeaderLabel: UILabel!
    @IBOutlet var dropDownDescriptionLabel: UILabel!
    @IBOutlet var dropDownSum: UILabel!
    @IBOutlet var DropDownCellTwoLabel: UILabel!
    @IBOutlet var dropDownTape: UIImageView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var tape: UIImageView!
    
    static let historyIdentifier = "historyIdentifier"
    static let operationIdentifier = "operationIdentifier"
    static let totalBalanceIdentifier = "totalBalanceIdentifier"
    static let DropDownTableViewCellIdentifier = "DropDownTableViewCellIdentifier"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    func changeConstraint(rowHeight: CGFloat ) {
        self.contentView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: rowHeight)
        self.backgroundColor = .red
    }
    
    func setCellColor(cell: UITableViewCell) {
        cell.backgroundColor =            whiteThemeBackground
        self.userImage.setImageColor(color: whiteThemeMainText)
        self.headerLabel.textColor =      whiteThemeMainText
        self.sumLabel.textColor =         whiteThemeMainText
        self.descriptionLabel.textColor = whiteThemeTranslucentText
    }
    
    func set(object: AccountsHistory) {
        self.headerLabel?.text = object.name
        guard descriptionLabel != nil else {return}
        if object.date != nil {
            self.descriptionLabel?.text = dateToString(date: object.date!)
        }else{
            descriptionLabel.text = "Balance"
        }
        self.sumLabel?.text = String(object.sum.currencyFormatter(ISO: object.currencyISO))
        if let image = object.image {
            userImage.image = UIImage(named: image)
        }else{ userImage.image = UIImage(named: "card")}
    }
    
//    func set(object: MonetaryCategory) {
//        self.headerLabel?.text = object.name
//        guard descriptionLabel != nil else {return}
//        if object.date != nil {
//            self.descriptionLabel?.text = dateToString(date: object.date!)
//        }else{
//            descriptionLabel.text = "Balance"
//        }
//        self.sumLabel?.text = String(object.sum.currencyFR)
//        if let imageData = object.image {
//            userImage.image = UIImage(named: object.image)
//        }else{ userImage.image = UIImage(named: "card")}
//        guard let typeLabel = typeLabel else {return}
//        typeLabel.text = object.initType()
//    }
    
    func setAccount(object: MonetaryAccount) {
        self.headerLabel?.text = object.name
        guard descriptionLabel != nil else {return}
        if object.date != nil {
            self.descriptionLabel?.text = dateToString(date: object.date!)
        }else{
            descriptionLabel.text = "Balance"
        }
        
        
        self.sumLabel?.text = String(object.balance.currencyFormatter(ISO: object.currencyISO))
        
        switch object.accountType {
        case 1 : userImage.image = UIImage(named: "card")
        case 2 : userImage.image = UIImage(named: "cash")
        case 3 : userImage.image = UIImage(named: "savings")
            
        default:
            userImage.image = UIImage(named: "card")
        }
        
    }



}



