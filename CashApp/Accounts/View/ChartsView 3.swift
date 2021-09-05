////
////  ChartsView.swift
////  CashApp
////
////  Created by Артур on 5.02.21.
////  Copyright © 2021 Артур. All rights reserved.
////
//
//import UIKit
//
//
//class ChartsView: UIView {
//    
//    var aaChartView: AAChartView = {
//        
//        var chartsView = AAChartView()
//        chartsView.isClearBackgroundColor = true // Если это не сделать, фон будет белым
//        chartsView.backgroundColor = .clear
//        chartsView.scrollEnabled = false
//        
//        chartsView.contentMode = .bottom
//        
//        return chartsView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        chartModelSettings()
//        setMyData()
//        chartInit()
//        self.backgroundColor = .clear
//        self.aaChartView.frame = self.bounds
//        self.addSubview(aaChartView)
// 
//        aaChartView.translatesAutoresizingMaskIntoConstraints = false
//        aaChartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        aaChartView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        aaChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        aaChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        aaChartView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        aaChartView.frame = self.bounds
//        aaChartView.backgroundColor = .black
//        
//        
//    }
//    let cardModel = MonetaryAccount()
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//  
//   
//    var chartSeries: [AASeriesElement]?
//    var aaChartModel = AAChartModel()
//
//    func chartInit() {
//
//        aaChartModel.series(chartSeries!)
//        aaChartView.aa_drawChartWithChartModel(aaChartModel)
//
//    }
//    func chartModelSettings() {
//        aaChartModel.axesTextColor("#F02C65")
//        aaChartModel.chartType(.spline)
//        aaChartModel.markerRadius = 0
//        aaChartModel.dataLabelsEnabled = false
//        aaChartModel.yAxisLabelsEnabled = false
//        aaChartModel.yAxisLineWidth(0)
//        aaChartModel.xAxisGridLineWidth(0)
//        aaChartModel.yAxisGridLineWidth(0)
//        aaChartModel.animationType(.easeInCubic)
//        aaChartModel.animationDuration(1000)
//
//    }
////    func chartViewSettings(){
////        aaChartView.isClearBackgroundColor = true // Если это не сделать, фон будет белым
////        aaChartView.backgroundColor = .clear
////        aaChartView.scrollEnabled = false
////        aaChartView.contentMode = .top
////
////        //aaChartView.contentHeight = 200
////
////    }
//    func setMyData() {
//        let gradientColor = AAGradientColor.linearGradient(direction: .toRight, startColor: "#F02C65" , endColor: "#2DB2FC")
//        let sumArray: [Double] = [20,-20,-10,-15,-25,0,250,-200,120,50,-450,222,15,26,-40,250,14,15,465,46,56,456,45]
//        var historyObject: [AccountsHistory] = []
//        var containsName: [String] = []
//        for i in historyObjects {
//            containsName.append(i.name)
//            if i.accountID == cardModel.accountID {
//                historyObject.insert(i, at: 0)// append почему то добавляет все наоборот
//                containsName.append(i.name)
//            }
//        }
////        for z in historyObject {
////            sumArray.append(-z.sum)
////        }
//        let shadow = AAShadow()
//        shadow.color = "#000000"
//        shadow.width(6)
//        shadow.offsetX(0)
//        shadow.offsetY(0)
//        shadow.opacity(0.1)
//
//        chartSeries = [(AASeriesElement().name("Total") .data(sumArray).color(gradientColor).lineWidth(3).shadow(shadow))]//изза того, что он нил, не получается использовать метод append
//
//
//    }
//
//    
//}
