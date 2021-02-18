//
//  LineChartCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 11.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import AAInfographics

class LineChartCollectionViewCell: UICollectionViewCell{
   
    
    
    
    let lineChartView = AAChartView()
    var model = AAChartModel()
    var element: [AASeriesElement] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lineChartView)
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        //применили констрейнты для собственной вьюшки
        lineChartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        lineChartView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        lineChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineChartView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lineChartView.scrollEnabled = false
     

        //model.animationDuration = 1300
    }
  
    
    func set(element: [AASeriesElement]) {
        model.series(element)
        lineChartView.aa_drawChartWithChartModel(model)
    }
    
    func disableAnimation(duration: Int) {
        model.animationDuration = duration
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
