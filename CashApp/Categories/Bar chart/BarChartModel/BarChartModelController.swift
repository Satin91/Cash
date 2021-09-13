//
//  BarChartModelController.swift
//  CashApp
//
//  Created by Артур on 13.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


class BarChartModelController {
    private let currencyModelController = CurrencyModelController()
  
    private  func getPersent(totalSum: Double, categorySum: Double) -> Double {
        let TS = totalSum.removeHundredthsFromEnd()
        let CS = categorySum.removeHundredthsFromEnd()
        let result = Double((Float(CS) / Float(TS)) * 100 )//.removeHundredthsFromEnd()
        return result
    }
    func convert(sum: Double, currency: String) -> Double {
        guard let mainCurrency = mainCurrency else {return 0}
        let value = currencyModelController.convert(sum, inputCurrency: currency, outputCurrency: mainCurrency.ISO)
        return value!
    }
    func getBarChartItems(categoryType: CategoryType) -> [BarChartModel] {
        let array = EnumeratedSequence(array: categoryGroup)
        var barChartModel = [BarChartModel]()
        var totalSum: Double = 0
        
        //get total sum
        for value in array.filter({$0.stringEntityType == categoryType}) {
            
            totalSum += convert(sum: value.sum, currency: value.currencyISO)
        }
        //
        for i in array.filter({$0.stringEntityType == categoryType}) {
            guard i.sum != 0 else {
                let model = BarChartModel(imageName: i.image, persent: 0, totalSum: 0, ISO: i.currencyISO)
                barChartModel.append(model)
                continue
            }
            
            let model = BarChartModel(
                imageName: i.image,
                persent: getPersent(totalSum: totalSum, categorySum: convert(sum: i.sum, currency: i.currencyISO)),
                totalSum: i.sum,
                ISO: i.currencyISO)
            barChartModel.append(model)
        }
        return barChartModel.sorted(by: {$0.persent > $1.persent})
    }
}
