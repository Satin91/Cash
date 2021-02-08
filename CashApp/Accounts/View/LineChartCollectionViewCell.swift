//
//  ChartCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 5.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import AAInfographics
class LineChartCollectionViewCell: UICollectionViewCell {
    
    //let accountObject = cardObjects[0]
    //let chartsModel: ChartsModel!
    
    var view: AAChartView!
   
    var model = AAChartModel()
    let a = AAChart()
    let sumArray: [Double] = [25,26,237,37,37,73]
    
    //var chartsView: ChartsView!
    func setAllSettings() {
       //VisualSettings
        var seriesElement: [AASeriesElement] = []
        view = AAChartView(frame: self.bounds)
        seriesElement = [(AASeriesElement().name(ContainerViewController.destinationName!) .data(sumArray))]
        model.series(seriesElement)
        //model.chartModelSettings(model: model)
        view.aa_drawChartWithChartModel(model)
        
        
        
        
    }
    func setSeries( object: MonetaryAccount) -> [AASeriesElement] {
        //var historyObject: [AccountsHistory] = []
        var chartSeries = [AASeriesElement()]
        var sumArray: [Double] = []
        for i in historyObjects {
            if i.accountIdentifier == object.accountID{
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        //setSeries(object: accountObject)
        //chartsView = ChartsView(frame: self.bounds)
        setAllSettings()
    
        view.backgroundColor = .red
        self.contentView.addSubview(view)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
