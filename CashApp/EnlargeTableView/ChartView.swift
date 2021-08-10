//
//  HeaderChart.swift
//  CashApp
//
//  Created by Артур on 3.08.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import Charts

class ChartView: LineChartView {
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.gridBackgroundColor = .clear
        self.leftAxis.gridColor = .clear
        self.xAxis.gridColor = .clear
        self.xAxis.axisLineColor = .clear
        self.xAxis.labelTextColor = .clear
        self.legend.enabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
