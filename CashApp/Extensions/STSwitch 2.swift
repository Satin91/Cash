//
//  STSwitch.swift
//  CashApp
//
//  Created by Артур on 6.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
class STSwitch: UIControl {
    
    
    public var onTintColor = ThemeManager2.currentTheme().contrastColor1 {
        didSet{
            self.setupUI()
        }
    }
    public var offTintColor = ThemeManager2.currentTheme().borderColor{
        didSet{
            self.setupUI()
        }
    }
    public var cornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var thumbTintColor = ThemeManager2.currentTheme().secondaryBackgroundColor {
        didSet{
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    
    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet{
            self.layoutSubviews()
        }
    }
    public var thumbSize = CGSize.zero {
        didSet{
            self.layoutSubviews()
        }
    }
    
    public var padding: CGFloat = 1 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var isOn = true
    public var animationDuration: Double = 0.5
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.thumbView.layer.shadowColor = UIColor.black.cgColor
        self.thumbView.layer.shadowRadius = 1.5
        self.thumbView.layer.shadowOpacity = 0.4
        self.thumbView.layer.shadowOffset = CGSize(width: 0.75, height: 2)
        self.addSubview(self.thumbView)
    }
    
    public override func layoutSubviews() {
      super.layoutSubviews()
        var side: CGFloat = 5
    if !self.isAnimating {
        self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        // thumb managment
        let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
     self.bounds.size.height - side, height: self.bounds.height - side)
        let yPostition = (self.bounds.size.height - thumbSize.height) / 2

    self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding - side, y: yPostition)
    self.offPoint = CGPoint(x: self.padding + side, y: yPostition)

    self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)

    self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
    
        setupUI()
         }

    }
    
    private func animate() {
       self.isOn = !self.isOn
       self.isAnimating = true
       UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                      initialSpringVelocity: 0.5, options: [.curveEaseOut, .beginFromCurrentState], animations: {
       self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
       self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
      }, completion: { _ in
         self.isAnimating = false
        self.sendActions(for: UIControl.Event.valueChanged)
      })
    }
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    
    
}
