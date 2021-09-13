//
//  LineChartCellTheme.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
extension LineChartCell {
    
    func setColors() {
        lineChartView.backgroundColor = .clear
        entryView.backgroundColor = colors.titleTextColor
        entryView.layer.setSmallShadow(color: colors.shadowColor)
        entryLabel.textColor = colors.backgroundcolor
        monthLabel.textColor = colors.titleTextColor
        self.backgroundColor = colors.secondaryBackgroundColor
        self.layer.setMiddleShadow(color: colors.shadowColor)
        textView.backgroundColor = .clear
        textView.textColor = colors.titleTextColor
        self.chartSize.backgroundColor = .clear
    }
}
