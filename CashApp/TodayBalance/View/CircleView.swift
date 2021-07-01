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
    private var persent: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "-14%"
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
        
        initConstraintsForLabel()
        createCircularPath()
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
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.setCircleShadow(color: ThemeManager.currentTheme().contrastColor2)
        //layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    func progressAnimation(duration: TimeInterval) {
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 0.75
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        circularProgressAnimation.autoreverses = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        
    }
    
    
}

