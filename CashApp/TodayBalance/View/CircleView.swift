//
//  CircleView.swift
//  CashApp
//
//  Created by Артур on 2.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var progressBackground = CAShapeLayer()
    private let object = todayBalanceObject
    private let colors = AppColors()
    var primaryValue = 0
    private var persent: TitleLabel = {
        let label = TitleLabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    func initConstraintsForLabel(){
        self.addSubview(persent)
        persent.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        persent.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        colors.loadColors()
        initConstraintsForLabel()
        createCircularPath()
        self.backgroundColor = .clear
        
    }

    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: self.frame.height / 2, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.setCircleShadow(color: colors.contrastColor1)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5
        progressLayer.strokeEnd = 0
        progressBackground.path = circularPath.cgPath
        progressBackground.fillColor = UIColor.clear.cgColor
        progressBackground.lineCap = .round
        progressBackground.lineWidth = 5
        progressBackground.strokeColor = colors.backgroundcolor.withAlphaComponent(0.6).cgColor
        progressBackground.strokeEnd = 1
     
        //progressLayer.strokeColor = ThemeManager.currentTheme().contrastColor2.cgColor
        progressLayer.setCircleShadow(color: colors.contrastColor2)
        //layer.addSublayer(circleLayer)
        layer.addSublayer(progressBackground)
        layer.addSublayer(progressLayer)
    }
    
    func percentage() -> CGFloat {
        var diff = CGFloat(0)
//        _ = fetchTodayBalance()
//        guard let object = object else {return 0}
        diff = (CGFloat(todayBalanceObject!.currentBalance) - CGFloat(todayBalanceObject!.commonBalance)) /
        
        abs(CGFloat(todayBalanceObject!.commonBalance)) * 100
        return diff
    }
    
    
    func quotient()->CGFloat {
        guard todayBalanceObject?.commonBalance != 0 else { return 0}
        let object = todayBalanceObject
        var diff = CGFloat(0)
        diff = percentage()
        return diff
    }

    
    func getPersent(currentlyBalance: Double, commonBalance: Double) -> (forLabel: Double,forCircle:CGFloat) {
        guard currentlyBalance + commonBalance != 0 else {
            return (0,0)
        }
      
     let quotient = quotient()
        if currentlyBalance > commonBalance {
            progressLayer.strokeColor = colors.greenColor.cgColor
            progressLayer.setCircleShadow(color: colors.greenColor)
        }else{
            progressLayer.strokeColor = colors.redColor.cgColor
            progressLayer.setCircleShadow(color: colors.redColor)
        }
        let circleValue = quotient > 0 ? quotient / 100 : (quotient - (quotient * 2)) / 100
      return (Double(quotient),circleValue)
    }
    
    func progressAnimation(currentlyBalance: Double, commonBalance: Double) {
        var value: (forLabel:Double,forCircle:CGFloat) = (0,0)
        
        if getPersent(currentlyBalance: currentlyBalance, commonBalance: commonBalance) != (0,0) {
            value = getPersent(currentlyBalance: currentlyBalance, commonBalance: commonBalance)
        }
        
        persent.countPersentAnimation(upto: value.forLabel)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 0.6
        circularProgressAnimation.toValue = value.forCircle
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        circularProgressAnimation.autoreverses = false
        progressLayer.strokeEnd = value.forCircle
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}

