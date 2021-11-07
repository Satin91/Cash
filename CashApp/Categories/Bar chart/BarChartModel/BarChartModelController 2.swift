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
  
    
    private func getCategorySumFromHistory(categoryID: String) -> Double {
        var sumCounter: Double = 0
        for historyObject in historyObjects {
            if historyObject.categoryID == categoryID {
                sumCounter += self.convert(sum: historyObject.sum, currency: historyObject.currencyISO)
            }
        }
        return sumCounter
    }
    private func getALLCategoriesSumFromHistory(categoryType: CategoryType) -> Double{
        var sumCounter: Double = 0
        let categoryTypeArray = EnumeratedSequence(array: categoryGroup)
        for i in categoryTypeArray.filter({$0.stringEntityType == categoryType}) {
            guard i.sum != 0 else {
                // Использую метод подсчета суммы со всех категорий для каждой категории чтобы получить общую сумму
                continue
            }
            sumCounter += getCategorySumFromHistory(categoryID: i.categoryID)
        }
        
        return sumCounter
    }
    // Получает процент объекта от общей суммы
    private func getPersent(totalSum: Double, categorySum: Double) -> Double {
        let TS = totalSum.removeHundredthsFromEnd()
        let CS = categorySum.removeHundredthsFromEnd()
        let result = Double((Float(CS) / Float(TS)) * 100 )//.removeHundredthsFromEnd()
        return result
    }
    // урощенная версия конвертера
    private func convert(sum: Double, currency: String) -> Double {
        guard let mainCurrency = mainCurrency else {return 0}
        let value = currencyModelController.convert(sum, inputCurrency: currency, outputCurrency: mainCurrency.ISO)
        return value!
    }
    
    // Возвращает массив объектов BarChartModel по заданному типу категорий
    func getBarChartItems(categoryType: CategoryType) -> [BarChartModel] {
        let array = EnumeratedSequence(array: categoryGroup)
        var barChartModel = [BarChartModel]()

        // Получает весь массив выбранного типа категорий
        for i in array.filter({$0.stringEntityType == categoryType}) {
//            guard i.sum != 0 else {
//                // в случае
//                let model = BarChartModel(imageName: i.image, persent: 0, totalSum: 0, ISO: i.currencyISO)
//                barChartModel.append(model)
//                continue
//            }
            
            // Получает общую сумму и сумму действующей категории по итерации
            let allSum = getALLCategoriesSumFromHistory(categoryType: categoryType)
            let categorySum = getCategorySumFromHistory(categoryID: i.categoryID)
            // 
            guard allSum != 0 else {
                let model = BarChartModel(imageName: i.image, persent: 0, totalSum: 0, ISO: i.currencyISO)
                barChartModel.append(model)
                continue
            }
            let model = BarChartModel(
                imageName: i.image,
                persent: getPersent(totalSum: allSum, categorySum: categorySum),
                totalSum: categorySum, // Изменить!!!
                ISO: mainCurrency!.ISO)
            barChartModel.append(model)
        }
        // сортирует по процентрому соотношению для дальнейшего отображения в tableView
        return barChartModel.sorted(by: {$0.persent > $1.persent})
    }
}
