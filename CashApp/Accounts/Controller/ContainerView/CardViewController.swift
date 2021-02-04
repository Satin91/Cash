//
//  scheduleViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import AAInfographics

class CardViewController: UIViewController {
    let detailViewController = AccountsDetailViewController()
    var cardModel: MonetaryAccount?
    
    var chart = AAChart()
    // colors : красный ("#F02C65") , темно синий("#44505E"), фоновый ("#F5F7F8")
    var aaChartView: AAChartView = {
        var chartView = AAChartView()
        chartView.isClearBackgroundColor = true // Если это не сделать, фон будет белым
        chartView.backgroundColor = whiteThemeBackground
        chartView.backgroundColor = .clear
        return chartView
    }()
    var chartSeries: [AASeriesElement]?
    
    
    static var CardViewBounds: CGRect!
    
    var aaChartModel = AAChartModel()
    var tableView: ChartsTableView!
    
    var isOperationDone = false //Булька для функции checkOperations
    let textViewIfOperationIsntDone = UITextView() //Текст если не было операций на счете
    var gradientViewForLineChartView: UIView = {
        var view = UIView()
        //view.selectivelyRoundedRadius(usingCorners: [.topLeft,.topRight], radius: CGSize(width: 4, height: 4), view: view)
        
        view.layer.cornerRadius = 8
        return view
    }()
    
    var chartGradient: CGGradient = {
        let colors =  [ whiteThemeTranslucentText.cgColor , whiteThemeBackground.cgColor] as CFArray //непонятно почему, возвращается нил если 2 раза color literal ставить
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors , locations: nil)
        var gradientView = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        return gradientView!
    }()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
      
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("view did load")
        CardViewController.CardViewBounds = self.view.bounds
        
        self.view.backgroundColor = whiteThemeBackground
        //aaChartModel.margin(top: -50, right: -50, bottom: -50, left: -50)
        setMyData()
        chartModelSettings()
        textViewSettings()
        aaChartModel.series(chartSeries!)
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        //self.view.addSubview(aaChartView)
        //self.view.addSubview(gradientViewForLineChartView)
        //checkOperations()
        //self.view.clipsToBounds = true
        tableView = ChartsTableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        let height = self.view.bounds.height * 0.5
        aaChartView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        aaChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // ВАЖНЕЙШАЯ ПОМЕТКА, без нее вьюха размером с родительским вью
        aaChartView.layer.cornerRadius = 8
        
        //addGradientForLineChartView() // func Gradient for line chart
        
        
        aaChartView.clipsToBounds = true
        self.view.layer.cornerRadius = 21
    }
    
    func addGradientForLineChartView() {
        gradientViewForLineChartView.frame = CGRect(x: 0, y: 0, width: aaChartView.bounds.width, height: aaChartView.bounds.height * 1.1)
        gradientViewForLineChartView.setGradient(view: gradientViewForLineChartView, startColor: whiteThemeBackground, endColor:whiteThemeTranslucentText, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        
        gradientViewForLineChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientViewForLineChartView.layer.masksToBounds = false
        gradientViewForLineChartView.clipsToBounds = true
    }
    func textViewSettings() {
        textViewIfOperationIsntDone.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        textViewIfOperationIsntDone.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textViewIfOperationIsntDone.backgroundColor = whiteThemeBackground
        textViewIfOperationIsntDone.font = UIFont(name: "SF Pro Text", size: 17)
        textViewIfOperationIsntDone.textColor = whiteThemeTranslucentText
        textViewIfOperationIsntDone.text = "A diagram of your transactions on this account will be displayed here, at the moment there are no transactions"
    }
    
    func setMyData() {
        let gradientColor = AAGradientColor.linearGradient(direction: .toBottom, startColor: "#44505E" , endColor: "#F5F7F8")
        var sumArray: [Double] = [20,-20,-10,-15,-25,0,250,-200,120,50,-450,222,15,26,-40,250]
        var historyObject: [AccountsHistory] = []
        var containsName: [String] = []
        for i in historyObjects {
            containsName.append(i.name)
            if i.accountIdentifier == cardModel?.accountID {
                historyObject.insert(i, at: 0)// append почему то добавляет все наоборот
                containsName.append(i.name)
            }
        }
//        for z in historyObject {
//            sumArray.append(-z.sum)
//        }
        let shadow = AAShadow()
        shadow.color = "#44505E"
        shadow.offsetX(2)
        shadow.offsetY(2)
        shadow.opacity(0.4)
  
        chartSeries = [(AASeriesElement().name("Total") .data(sumArray).color("#44505E").lineWidth(3).shadow(shadow))]//изза того, что он нил, не получается использовать метод append
        
        
    }
    func chartModelSettings() {
        let gradientColor = AAGradientColor.linearGradient(direction: .toBottom, startColor: "#44505E" , endColor: "#44505E")
        let gradientForBackground = AAGradientColor.linearGradient(direction: .toTop, startColor: "#44505E", endColor: "#44505E")
        aaChartModel.chartType(.spline)
        
        aaChartModel.markerSymbol(.circle) // Это если радиус не стоит 0
        aaChartModel.yAxisVisible = false
        aaChartModel.markerRadius = 3
        aaChartModel.animationType(.easeInSine)
        aaChartModel.legendEnabled = false
        aaChartModel.animationDuration(1200)
        
        print("\(chartSeries![0].name) card view controller")
//        if chartSeries![0].data!.count > 15 {
//            let objectWidth = Int(self.view.frame.width / 15)
//
//        aaChartModel.scrollablePlotArea(AAScrollablePlotArea()
//                    .minWidth(Int(self.view.frame.width) + (chartSeries![0].data!.count - 15) * objectWidth)
//                    .scrollPositionX(1)
//                    .scrollPositionY(500)
//                )
//        }
        
        
        aaChartModel.colorsTheme([gradientColor])
        
        aaChartModel.title("March")
        aaChartModel.titleStyle(.init(color: "#44505E"))
        aaChartModel.subtitle("Total: 1350")
        aaChartModel.subtitleStyle(.init(color: "#44505E"))
        
        aaChartModel.categories(["Jan,2", "Feb,2", "Mar,2", "Apr,2", "May,2", "Jun,2",
                               "Jul,2", "Aug,2", "Sep,2", "Oct,2", "Nov,2", "Dec,2"])
        aaChartModel.axesTextColor("#44505E")
        aaChartModel.backgroundColor = "#F5F7F8"
        
        
    }
    
    //    func checkOperations() {
    //
    //        if chartDataEntry.count != 0 {
    //            isOperationDone = true
    //
    //        }else{
    //            isOperationDone = true
    //        }
    //        switch isOperationDone {
    //        case true:
    //            self.view.addSubview(aaChartView)
    //
    //        case false:
    //            self.view.addSubview(textViewIfOperationIsntDone)
    //        }
    //    }
    
    
    
    //extension LineChartView {
    //    func chartViewSettings(lineChart: LineChartView) -> LineChartView {
    //
    //        lineChart.backgroundColor = .clear
    //        lineChart.rightAxis.enabled = false
    //        lineChart.xAxis.labelPosition = .bottom
    //        lineChart.xAxis.labelFont = .systemFont(ofSize: 17, weight: .light)
    //        lineChart.xAxis.labelTextColor = whiteThemeMainText
    //        lineChart.xAxis.gridColor = whiteThemeTranslucentText
    //        lineChart.xAxis.drawAxisLineEnabled = false
    //        lineChart.xAxis.drawGridLinesEnabled = false
    //
    //        lineChart.leftAxis.drawLabelsEnabled = false
    //        lineChart.leftAxis.labelFont = .systemFont(ofSize: 17)
    //        lineChart.leftAxis.labelTextColor = whiteThemeMainText
    //        lineChart.leftAxis.drawAxisLineEnabled = false
    //        lineChart.leftAxis.labelPosition = .outsideChart
    //
    //
    //
    //        lineChart.backgroundColor = .clear
    //
    //
    //        //lineChart.legend.drawInside = true
    //        lineChart.rightAxis.drawGridLinesEnabled = true
    //        lineChart.leftAxis.drawGridLinesEnabled = true
    //        lineChart.leftAxis.gridLineDashPhase = 5
    //        lineChart.leftAxis.gridLineDashLengths = [CGFloat(5),CGFloat(6)]
    //        lineChart.leftAxis.gridColor = whiteThemeTranslucentText
    //        lineChart.legend.textColor = .clear // legend - текст названия счета
    //        lineChart.legend.formSize = 0
    //        lineChart.legend.drawInside = true
    //
    //        lineChart.animate(yAxisDuration: 0.6)
    //        lineChart.doubleTapToZoomEnabled = false
    //
    //
    //        return lineChart
    //    }
    //}
//    .name("Tokyoooooooooooooooooooo")
//    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]),
//          AASeriesElement()
//            .name("New York")
//            .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]),
//          AASeriesElement()
//            .name("Berlin")
//            .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]),
//          AASeriesElement()
//            .name("London")
//            .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]),
//          AASeriesElement()
//            .name("Minsk")
//            .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]),
//          AASeriesElement()
//            .name("Warshaw")
//            .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]),
//          AASeriesElement()
//            .name("Saints Peterburg")
//            .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]),
//          AASeriesElement()
//            .name("Kiiv")
//            .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8,3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8])
}
