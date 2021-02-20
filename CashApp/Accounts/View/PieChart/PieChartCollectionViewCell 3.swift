//
//  PieChardCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 11.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import AAInfographics

class PieChartCollectionViewCell: UICollectionViewCell {
    
    let pieChartView = AAChartView()
    var model = AAChartModel()
    var element: [AASeriesElement] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        model.chartType(.pie)
        addSubview(pieChartView)
        
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        //применили констрейнты для собственной вьюшки
        pieChartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        pieChartView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        pieChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pieChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pieChartView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pieChartView.scrollEnabled = false
        model.animationDuration = 0
    }
    
    func set(element: [AASeriesElement]) {
        model.series(element)
        pieChartView.aa_drawChartWithChartModel(model)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
