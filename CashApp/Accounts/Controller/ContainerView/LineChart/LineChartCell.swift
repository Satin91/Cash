//
//  LineChartCell.swift
//  CashApp
//
//  Created by Артур on 15.03.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import AAInfographics
class LineChartCell: UICollectionViewCell {
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var chartSize: UIView!
    @IBOutlet var textView: UITextView!
    var lineChartView = AAChartView()
    var model: AAChartModel = {
        let model = AAChartModel()
        model.animationType(.easeFrom)
        model.title = ""
        model.subtitle = ""
        model.tooltipValueSuffix("USD")
        model.chartType(.spline)
        model.dataLabelsEnabled = false
        model.xAxisTitle = ""
        model.legendEnabled = false
        model.touchEventEnabled = false
        model.xAxisLabelsEnabled = false
        model.yAxisLabelsEnabled = false
        model.xAxisVisible = true
        
        model.yAxisLineWidth = 0
        model.xAxisGridLineWidth = 0
        model.yAxisGridLineWidth = 0
      //  model.stacking(.none)
        
        model.margin(top: 10, right: 10, bottom: 0, left: 10)
        
        return model
    }()
    var element: [AASeriesElement] = []

    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        topConstraint.constant = self.bounds.height / 4
        chartSize.addSubview(lineChartView)
        initConstraints(view: lineChartView, to: chartSize)
        lineChartView.scrollEnabled = false
        
        chartViewVisualSettings()
        cellVisualSettings()
        
    }
   
    func cellVisualSettings() {
        monthLabel.textColor = whiteThemeMainText
        self.backgroundColor = .clear
        chartSize.backgroundColor = .clear
        lineChartView.backgroundColor = .clear
        lineChartView.isClearBackgroundColor = true
        lineChartView.scrollEnabled = false
        
        textView.backgroundColor = .clear
        textView.textColor = whiteThemeMainText
        textView.font = .systemFont(ofSize: 17)
    }
    
    func changeTopConstraint() {
        UIView.animate(withDuration: 1) {
            self.topConstraint.constant = 0
        }
    }
    
    func chartViewVisualSettings() {
       
//        model.categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
//                           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
    }
    
    func set(element: [AASeriesElement]) {

     
        guard element.first?.name != "ArrayIsEmpty" else {
            lineChartView.isHidden = true
            textView.isHidden = false
            textView.text = "You have not made a single transaction"
            monthLabel.text = ""
            return
        }

        for i in element {
            if i.data!.count == 1 {
                
                lineChartView.isHidden = true
                textView.isHidden = false
                textView.text = "You need at least one transaction in this month to display the chart!"
                monthLabel.text = i.name
            }else {
                
                elementVisualSettings(element: i)
                lineChartView.isHidden = false
                textView.isHidden = true
                model.series(element)
                monthLabel.text = i.name
                lineChartView.aa_drawChartWithChartModel(model)
            }
        }


        //You need at least one transaction to display the chart!


    }
    
    
    func elementVisualSettings(element: AASeriesElement) {
        element.lineWidth = 4
        var shadow = AAShadow()
        shadow.offsetX = 2
        shadow.offsetY = 2
        element.shadow(shadow)
    }
}
