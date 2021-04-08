//
//  ChartsModel.swift
//  CashApp
//
//  Created by Артур on 8.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import AAInfographics

extension AAChartModel {
    func chartModelSettings(model: AAChartModel) {
        model.axesTextColor("#F02C65")
        model.chartType(.spline)
        model.markerRadius = 0
        model.dataLabelsEnabled = false
        model.yAxisLabelsEnabled = false
        model.yAxisLineWidth(0)
        model.xAxisGridLineWidth(0)
        model.yAxisGridLineWidth(0)
        model.animationType(.easeInCubic)
        model.animationDuration(1000)
        
    }
    
    func setSeries( object: MonetaryAccount) -> [AASeriesElement] {
        //var historyObject: [AccountsHistory] = []
        var chartSeries = [AASeriesElement()]
        var sumArray: [Double] = []
        for i in historyObjects {
            if i.accountID == object.accountID{
                sumArray.append(i.sum)
            }
            chartSeries.append(AASeriesElement()
                                .name(object.name)
                                .data(sumArray)
                                .color("#F02C65")
                                .lineWidth(3))
        }
        
        return chartSeries
    }
}
class ChartsModel {
    
    


}

