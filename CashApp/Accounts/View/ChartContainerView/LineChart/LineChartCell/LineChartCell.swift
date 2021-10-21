//
//  LineChartCell.swift
//  CashApp
//
//  Created by Артур on 15.03.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Charts

class LineChartCell: UICollectionViewCell, ChartViewDelegate {
    
    let colors = AppColors()
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var chartSize: UIView!
    @IBOutlet var textView: UITextView!
    var lineChartView = ChartView()
    
    @IBOutlet var nextMonthImage: UIImageView!
    @IBOutlet var previousMonthImage: UIImageView!
    func setupImages() {
        nextMonthImage.setImageColor(color: colors.titleTextColor)
        previousMonthImage.setImageColor(color: colors.titleTextColor)
    }
    func chartVisualSettings(chartDataSet: LineChartDataSet) {
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.circleRadius = 3
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.setCircleColor(colors.contrastColor1)
        chartDataSet.lineWidth = 2.5
        chartDataSet.setColor(colors.redColor)
        chartDataSet.mode = .cubicBezier
        chartDataSet.drawValuesEnabled = false
        chartDataSet.lineCapType = .square
        chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        chartDataSet.highlightLineWidth = 2
        chartDataSet.highlightColor = colors.borderColor.withAlphaComponent(0.7)
        //chartDataSet.fillFormatter = .
        //chartDataSet.highlightLineDashPhase = CGFloat(4)
       // chartDataSet.drawFilledEnabled = true
        chartDataSet.highlightLineDashLengths = [6,6]
    }
    enum NavigationImages {
        case next
        case previous
        case all
        case none
    }
    func showAndHideNavigationImages(navigation: NavigationImages) {
        nextMonthImage.isHidden = true
        previousMonthImage.isHidden = true
        switch navigation {
        case .next:
            nextMonthImage.isHidden = false
        case .previous:
            previousMonthImage.isHidden = false
        case .all:
            nextMonthImage.isHidden = false
            previousMonthImage.isHidden = false
        case .none:
            nextMonthImage.isHidden = true
            previousMonthImage.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colors.loadColors()
        self.setColors()
        setupImages()
        chartSize.addSubview(lineChartView)
        //initConstraints(view: lineChartView, to: chartSize)
        chartSize.addSubview(lineChartView)
        createConstraints()
        setupChartView()
        cellVisualSettings()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        chartSize.addGestureRecognizer(gesture)
    }

    func createConstraints(){
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineChartView.trailingAnchor.constraint(equalTo: chartSize.trailingAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: chartSize.leadingAnchor),
            lineChartView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20),
            lineChartView.bottomAnchor.constraint(equalTo: chartSize.bottomAnchor)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        createConstraints()
    }
    
    func setupChartView() {
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 17, weight: .light)
        lineChartView.leftAxis.labelCount = 2
        lineChartView.delegate = self
        lineChartView.highlightValue(x: 50, dataSetIndex: 20)
        lineChartView.setScaleEnabled(false)
        let gestureRecognozer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        lineChartView.addGestureRecognizer(gestureRecognozer)
    }
    var entryView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 12
        view.alpha = 0
        view.isUserInteractionEnabled = false
        return view
    }()
    var entryLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard lineChartView.isHidden == false else {return}
        let location = sender.location(in: lineChartView)
        let highlight = lineChartView.getHighlightByTouchPoint(location)
        let entry = lineChartView.getEntryByTouchPoint(point: location)
        let circleLocation = lineChartView.getPosition(entry: entry!, axis: .left)
        let highlite: () = lineChartView.highlightValue(highlight)
        guard let entry1 = entry else {return}
        self.createEntryView(entry: entry1, location: circleLocation)
    }

   

    func bounds(view: UIView) {
        view.clipsToBounds = false
        view.layer.masksToBounds = false
    }
   
    func cellVisualSettings() {
       
        monthLabel.font = .systemFont(ofSize: 28, weight: .medium)
        self.layer.cornerRadius = 25
        self.layer.cornerCurve = .continuous
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 17)
        self.layer.masksToBounds = false
        bounds(view: self)
        bounds(view: chartSize)
        
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        UIView.animate(withDuration: 0.2) {
            self.entryView.alpha = 0
        } completion: { (ifTrue) in
            self.entryView.removeFromSuperview()
        }

        
    }
    var ISO = ""
    
    func createEntryView(entry: ChartDataEntry, location: CGPoint) {
        
        if self.subviews.contains(self.entryView){
            self.animateEntryView {
                self.entryView.frame = CGRect(x: location.x, y: location.y + 10, width: 120, height: 40)
                self.entryView.frame.origin.x = location.x - self.entryView.bounds.width / 2
                self.entryLabel.text = entry.y.currencyFormatter(ISO: self.ISO)
                if self.entryView.frame.minX < self.bounds.minX {
                    self.entryView.frame.origin.x = 0
                }else if self.entryView.frame.maxX > self.bounds.maxX {
                    self.entryView.frame.origin.x = self.bounds.maxX - self.entryView.bounds.width
                }
                
            }
        }else{
            
            self.addSubview(self.entryView)
            self.entryView.addSubview(self.entryLabel)
            self.entryView.frame = CGRect(x: location.x, y: location.y + 20, width: 120, height: 40)
            self.entryView.frame.origin.x = location.x - self.entryView.bounds.width / 2
            self.entryLabel.frame = self.entryView.bounds
            self.entryLabel.text = entry.y.currencyFormatter(ISO: self.ISO)
            self.entryLabel.textAlignment = .center
            if self.entryView.frame.minX < self.bounds.minX {
                self.entryView.frame.origin.x = 0
            }else if self.entryView.frame.maxX > self.bounds.maxX {
                self.entryView.frame.origin.x = self.bounds.maxX - self.entryView.bounds.width
            }
            UIView.animate(withDuration: 0.2) {
                self.entryView.alpha = 1
            }

          
        }
       
        
      
        
       
           
            
        
        
        
    }
    func set(element: LineChartDataModel) {
        ISO = element.account.currencyISO
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        
        switch element.chartDataSet.label {
        case "ArrayIsEmpty" :
            lineChartView.isHidden = true
            textView.isHidden = false
            textView.text = NSLocalizedString("no_transactions", comment: "")
            monthLabel.text = formatter.string(from: element.date)
        case "ArrayIsIncomplete":
            lineChartView.isHidden = true
            textView.isHidden = false
            textView.text = NSLocalizedString("need_at_least_one", comment: "")
            monthLabel.text = formatter.string(from: element.date)
        default:
            lineChartView.isHidden = false
            chartVisualSettings(chartDataSet: element.chartDataSet)
            let chartData = LineChartData(dataSet: element.chartDataSet)
            lineChartView.data = chartData
            lineChartView.legend.enabled = false
            textView.isHidden = true
            monthLabel.text = formatter.string(from: element.date).capitalizingFirstLetter()
         
        }
       
    }
    func animateEntryView(animate: @escaping () -> (Void) ) {
        
       
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: animate)
    }
    
//    func elementVisualSettings(element: AASeriesElement) {
//        element.lineWidth = 2
//    }
}
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
