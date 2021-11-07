//
//  CurrencyTableViewCell.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


class CurrencyTableViewCell: UITableViewCell {
    let colors = AppColors()
    @IBOutlet var currencyImage: UIImageView!
    @IBOutlet var ISOLabel: UILabel!
    @IBOutlet var isMainCurrencyLabel: UILabel!
    @IBOutlet var currencyDescriptionLabel: UILabel!
    var mainCurrency: CurrencyObject? = {
        guard let object = userCurrencyObjects.first else {return nil}
        return object
    }()
    let currencyModelController = CurrencyModelController()
    
    override func prepareForReuse() {  // Конвертирует валюту в ту, которая в нулевом индексе(first)
        super.prepareForReuse()
        guard let object = userCurrencyObjects.first else {return}
        mainCurrency = object
    }
    func setupImage(){
        self.currencyImage.layer.setCircleShadow(color: colors.shadowColor.withAlphaComponent(0.2))
        self.currencyImage.layer.masksToBounds = false
    }
    func visualSettings() {
        ISOLabel.font = .systemFont(ofSize: 14, weight: .regular)
        isMainCurrencyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        currencyDescriptionLabel.font = .systemFont(ofSize: 21, weight: .regular)
        currencyDescriptionLabel.minimumScaleFactor = 0.5
        currencyDescriptionLabel.adjustsFontSizeToFitWidth = true
        //currencyImage.layer.cornerRadius = 5
        //currencyImage.layer.borderWidth = 1.5
        currencyImage.layer.setMiddleShadow(color: colors.shadowColor)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
   
    func defaultSet(currencyObject: CurrencyObject){
        getCurrenciesByPriorities()
        visualSettings()
        currencyImage.image = UIImage(named: currencyObject.ISO)
        ISOLabel.text = currencyObject.ISO
        currencyDescriptionLabel.text = CurrencyList.CurrencyName(rawValue: currencyObject.ISO)?.getRaw
        self.setCellColors()
    }
    
    func converterSet(currencyObject: CurrencyObject, enteredSum: Double){
        ISOLabel.text = currencyObject.ISO
        let convertedSum = currencyModelController.convert(enteredSum, inputCurrency: mainCurrency?.ISO, outputCurrency: currencyObject.ISO)?.formattedWithSeparator
        currencyDescriptionLabel.text = convertedSum
        self.setCellColors()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds.inset(by: UIEdgeInsets(top: 10, left: 22, bottom: 10, right: 22))
        setupImage()
    }
    
    func setupContentView() {
        self.contentView.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.cornerCurve = .continuous
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        colors.loadColors()
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        setupContentView()
        
    }
    }
    
