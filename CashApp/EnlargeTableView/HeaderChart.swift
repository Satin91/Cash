//
//  HeaderChart.swift
//  CashApp
//
//  Created by Артур on 3.08.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import Charts

class HeaderChart: UIView {
    
    var chartView: LineChartView = {
        let chart = LineChartView()
        return chart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
