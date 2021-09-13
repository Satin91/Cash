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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let object = userCurrencyObjects.first else {return}
        mainCurrency = object
    }
    
    func visualSettings() {
        ISOLabel.font = .systemFont(ofSize: 14, weight: .regular)
        isMainCurrencyLabel.font = .systemFont(ofSize: 17, weight: .regular)
        currencyDescriptionLabel.font = .systemFont(ofSize: 21, weight: .regular)
        
        currencyImage.layer.cornerRadius = 5
        currencyImage.layer.borderWidth = 1.5
        
        
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
   
    func defaultSet(currencyObject: CurrencyObject){
        getCurrenciesByPriorities()
        visualSettings()
        currencyImage.image = UIImage(named: currencyObject.ISO)
        isMainCurrencyLabel.text = currencyObject.ISO == mainCurrency?.ISO ?
              NSLocalizedString("main_currency_cell", comment: "")
            : NSLocalizedString("additional_currency_cell", comment: "")
        isMainCurrencyLabel.textColor = currencyObject.ISO == mainCurrency?.ISO ?
            colors.contrastColor1
            :colors.subtitleTextColor
        ISOLabel.text = currencyObject.ISO
        currencyDescriptionLabel.text = CurrencyList.CurrencyName(rawValue: currencyObject.ISO)?.getRaw
        self.setCellColors()
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
    
