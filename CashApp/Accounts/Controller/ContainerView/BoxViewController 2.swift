//
//  BoxViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController {
    
    
    @IBOutlet var circleView: UIView!
    
    //// Color Declarations
    let color2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

  


    var shadowgroundCircle = CAShapeLayer()
    var backgroundCircle = CAShapeLayer()
    var foregroundCircle = CAShapeLayer()
    
    
    let totalBalance = AccountsDetailViewController()
    var boxModel: MonetaryEntity?
    
    var gradientLayer = CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .none
        
        backgroundCircle = setupCircle(circle: backgroundCircle, color: #colorLiteral(red: 0.3665460201, green: 0.9103448479, blue: 0.9882352941, alpha: 1).cgColor , stokeEnd: 1)
        foregroundCircle = setupCircle(circle: foregroundCircle, color: UIColor.red.cgColor, stokeEnd: 0)
        gradientFofStroke(stroke: foregroundCircle)
        //circleShadow(circle: foregroundCircle)
        /// Разобраться с тенями
        
        
        
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

        setProgressWithAnimation(duration: 0.5, endAngle: 0.8)
        
        
    }
    
    
    
    func gradientFofStroke(stroke: CAShapeLayer) {
        
        //памятка для градиента : 0.0 Сверху слеава. 1.1 снизу справа
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 0.5)
        //Gradient почему то понимает только cgcolor
        gradientLayer.colors = [whiteThemeFirstGradientColor.cgColor, whiteThemeSecondGradientColor.cgColor]
        
        //Оказывается все проще получилось чем я думал сделать сразу
        let rect = CGRect(x: 0 , y: 0, width: circleView.frame.width, height: circleView.frame.height)
        gradientLayer.frame = rect
        gradientLayer.mask = stroke
        

        circleView.layer.addSublayer(gradientLayer)
        
    }

    
    func setupCircle(circle: CAShapeLayer, color: CGColor,stokeEnd: CGFloat) -> CAShapeLayer {
        let circle = circle
        let circleSize: CGFloat = circleView.frame.height / 3
        circleView.backgroundColor = .none
        let startAngle = -CGFloat.pi / 2 // Так как о начинается справа, нужное число отрицательное
        let endAngle = CGFloat.pi * 1.5 // таким образом pi/2 + p * 1.5 получается 2pi = диаметр
        let circularPath = UIBezierPath(arcCenter: circleView.center, radius: circleSize, startAngle:startAngle , endAngle: endAngle , clockwise: true)
        
        
        circleView.backgroundColor = whiteThemeBackground
        //Properties of line
        circle.path = circularPath.cgPath
        circle.strokeColor = color
        circle.fillColor = .none
        circle.lineWidth = circleSize / 5
        //Radius in line
        circle.lineCap = .round
        circle.strokeEnd = stokeEnd
        
        //Уточнить по поводу тени.
        
        circleView.layer.addSublayer(circle)
        return circle
        //
        // маска должна идти после addSublayer
        
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, endAngle: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = endAngle
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        foregroundCircle.strokeEnd = CGFloat(endAngle)
        foregroundCircle.add(animation, forKey: "animateprogress")
    }
    //           Set shadow
    func circleShadow (circle: CAShapeLayer){
        circle.shadowOffset = CGSize(width: -2  , height: -2)
        circle.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        circle.shadowOpacity = 1.0
        circle.shadowRadius = 2
    }
    
    
}
