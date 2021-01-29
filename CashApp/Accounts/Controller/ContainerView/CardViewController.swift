//
//  scheduleViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import Charts

class CardViewController: UIViewController,ChartViewDelegate {
    let detailViewController = AccountsDetailViewController()
    var chartDataEntry: [ChartDataEntry] = []
    var cardModel: MonetaryAccount?
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
    var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.chartViewSettings(lineChart: chartView)
        
        return chartView
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1) {
            self.lineChartView.frame.origin.y =  self.lineChartView.frame.origin.y * 2
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        self.view.backgroundColor = .clear
        
        setMyData()
        textViewSettings()
        //self.view.addSubview(gradientViewForLineChartView)
        checkOperations()
        lineChartView.xAxis.setLabelCount(2, force: true)
        lineChartView.leftAxis.setLabelCount(7, force: true)
        
    }

    
    override func viewDidLayoutSubviews() {
        let height = self.view.bounds.height * 0.5
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: height)
        lineChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // ВАЖНЕЙШАЯ ПОМЕТКА, без нее вьюха размером с родительским вью
        lineChartView.layer.cornerRadius = 8
        addGradientForLineChartView() // func Gradient for line chart
        
       
        
        lineChartView.clipsToBounds = true
        self.view.layer.cornerRadius = 21
    }
    
    func addGradientForLineChartView() {
        gradientViewForLineChartView.frame = CGRect(x: 0, y: 0, width: lineChartView.bounds.width, height: lineChartView.bounds.height * 1.1)
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
    
    func checkOperations() {
        
        if chartDataEntry.count != 0 {
            isOperationDone = true
            
        }else{
            isOperationDone = false
        }
        switch isOperationDone {
        case true:
            self.view.addSubview(lineChartView)
            
        case false:
            self.view.addSubview(textViewIfOperationIsntDone)
        }
    }
    
    func setMyData() {
        var step = Double(0)
        var x = Double(0)
        var y = Double(0)
        var historyObject: [AccountsHistory] = []
        for i in historyObjects {
            if i.accountIdentifier == cardModel?.accountID {
                historyObject.insert(i, at: 0)// append почему то добавляет все наоборот
            }
        }
        
            for z in historyObject {
                y = z.sum
                x = step
                
                chartDataEntry.append(ChartDataEntry(x: x, y: y))
                step += 15
            }
        
        
        let set = LineChartDataSet(entries: chartDataEntry, label: cardModel?.name)
        
        set.drawCirclesEnabled = true // Кружки включил
        set.circleHoleColor = whiteThemeRed
        set.setCircleColor(whiteThemeMainText)
        set.circleRadius = 4
        
        set.formLineWidth = 0.2
        set.formLineDashPhase = 5
        set.highlightColor = whiteThemeMainText
        set.highlightLineDashLengths = [CGFloat(2), CGFloat(5)]
        
        
        set.lineCapType = .square
        
        set.fillAlpha = 0.8
        set.fill = Fill(linearGradient: chartGradient, angle: 270)
        
        set.drawFilledEnabled = true
        set.drawValuesEnabled = true
        
        set.cubicIntensity =  0.2
        set.mode = .cubicBezier
        set.setColor(whiteThemeMainText)
        set.lineWidth = 1.5
        
        
        let data = LineChartData(dataSet: set)
        lineChartView.data = data
    }
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
}

extension LineChartView {
    func chartViewSettings(lineChart: LineChartView) -> LineChartView {
        
        lineChart.backgroundColor = .clear
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .systemFont(ofSize: 17, weight: .light)
        lineChart.xAxis.labelTextColor = whiteThemeMainText
        lineChart.xAxis.gridColor = whiteThemeTranslucentText
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.leftAxis.labelFont = .systemFont(ofSize: 17)
        lineChart.leftAxis.labelTextColor = whiteThemeMainText
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.labelPosition = .outsideChart
        
        
        
        lineChart.backgroundColor = .clear
        
        
        //lineChart.legend.drawInside = true
        lineChart.rightAxis.drawGridLinesEnabled = true
        lineChart.leftAxis.drawGridLinesEnabled = true
        lineChart.leftAxis.gridLineDashPhase = 5
        lineChart.leftAxis.gridLineDashLengths = [CGFloat(5),CGFloat(6)]
        lineChart.leftAxis.gridColor = whiteThemeTranslucentText
        lineChart.legend.textColor = .clear // legend - текст названия счета
        lineChart.legend.formSize = 0
        lineChart.legend.drawInside = true
        
        lineChart.animate(yAxisDuration: 0.6)
        lineChart.doubleTapToZoomEnabled = false
        
        
        return lineChart
    }
}
