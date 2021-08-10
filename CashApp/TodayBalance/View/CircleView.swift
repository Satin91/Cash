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
    private let object = todayBalanceObject
    var primaryValue = 0
    private var persent: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme().titleTextColor
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
    var startValue = 0
  
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initConstraintsForLabel()
        createCircularPath()
        
        //persent.text = String(Int(getPersent() * 100)) + "%"
    }

    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: self.frame.height / 2, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.setCircleShadow(color: ThemeManager.currentTheme().contrastColor1)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5
        progressLayer.strokeEnd = 0
        //progressLayer.strokeColor = ThemeManager.currentTheme().contrastColor2.cgColor
        progressLayer.setCircleShadow(color: ThemeManager.currentTheme().contrastColor2)
        //layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    
    
    func quotient()->CGFloat {
        guard todayBalanceObject?.commonBalance != 0 else { return 0}
        let object = todayBalanceObject
        var diff = CGFloat(0)
        if CGFloat(object!.commonBalance) > CGFloat(object!.currentBalance) {
        diff = CGFloat(object!.commonBalance) / CGFloat(object!.currentBalance) * 100 - 100
        }else{
            diff = 100 - CGFloat(object!.currentBalance) / CGFloat(object!.commonBalance) * 100
        }
        
        
        return diff
    }

    func getPersent(currentlyBalance: Double, commonBalance: Double) -> (forLabel: Double,forCircle:CGFloat) {
        guard currentlyBalance + commonBalance != 0 else {
            return (0,0)
        }
      
     let quotient = quotient()
        if quotient > 0 {
            progressLayer.strokeColor = ThemeManager.currentTheme().contrastColor1.cgColor
            progressLayer.setCircleShadow(color: ThemeManager.currentTheme().contrastColor1)
        }else{
            progressLayer.strokeColor = ThemeManager.currentTheme().contrastColor2.cgColor
            progressLayer.setCircleShadow(color: ThemeManager.currentTheme().contrastColor2)
        }
        let circleValue = quotient > 0 ? quotient / 100 : (quotient - (quotient * 2)) / 100
        print(circleValue)
        
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

