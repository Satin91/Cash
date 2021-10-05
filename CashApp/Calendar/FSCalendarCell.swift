//
//  FSCalendarCell.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import FSCalendar
import Themer


enum CellStyle {
    case DIYCalendar
    case defaultCalendar
}
enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}
class DIYFSCalendarCell: FSCalendarCell{
    weak var selectionLayer: CAShapeLayer!
    weak var themeBackgroundColor: UIColor!
    weak var themeSecondaryBackgroundColor: UIColor!
    weak var selectionBackgroundColor: UIColor!
    weak var borderColor: UIColor!
    weak var contrastColor: UIColor!
     var eventView: UIView!
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundView?.backgroundColor = themeBackgroundColor
       // self.eventView.isHidden = true
        self.selectionLayer.isHidden = true
    }
    override init!(frame: CGRect) {
        super.init(frame: frame)
        Themer.shared.register(target: self, action: DIYFSCalendarCell.theme(_:))
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = self.selectionBackgroundColor.withAlphaComponent(0.4).cgColor
        selectionLayer.isHidden = true
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        let contentView = UIView(frame: self.bounds)
        contentView.backgroundColor = self.themeBackgroundColor
        contentView.layer.cornerRadius = 5
        self.eventView = UIView(frame: self.bounds)
        self.eventView.backgroundColor = contrastColor
        //createEventView(toView: contentView)
        self.backgroundView = contentView
        self.backgroundView?.insertSubview(eventView, at: 10)
    }
    
    func setStyle(cellStyle: CellStyle) {
        switch cellStyle {
        case .DIYCalendar :
            backgroundView?.backgroundColor = themeBackgroundColor.withAlphaComponent(0.8)
            
            
        case .defaultCalendar:
            backgroundView?.backgroundColor = self.themeSecondaryBackgroundColor.withAlphaComponent(0.8)
            
            
        }
    }
    let duration = 1
    func endDateReserveAnimations() {
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {

            self.backgroundView!.backgroundColor = .red
            print("asdasd")

        }, completion: nil)
    }
    func createEventView(toView: UIView){
        let side: CGFloat = 6
        let width = toView.bounds.width - side * 2
        let height = toView.bounds.height / 15
        
        
        self.eventView.frame = CGRect(x: side, y: toView.bounds.height - height - (side) , width: width, height: height)
        
        self.eventView.layer.cornerRadius = self.eventView.bounds.height / 4
        self.eventView.backgroundColor = contrastColor
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset: CGFloat = 14
        
        //self.eventView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height / 5)
        self.backgroundView?.frame = self.bounds.inset(by: UIEdgeInsets(top: inset, left: 4, bottom: 4, right: 4))
        
        self.selectionLayer.frame = self.bounds.inset(by: UIEdgeInsets(top: inset, left: 0, bottom:  inset, right: 0) )
        let leftFrame =             self.selectionLayer.bounds.inset(by: UIEdgeInsets(top: 0, left: 4, bottom:  0, right: 0))
        let rightFrame =            self.selectionLayer.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom:  0, right: 4))
        //self.bounds.inset(by: UIEdgeInsets(top: self.bounds.height / 5, left: 0, bottom:  self.bounds.height / 5, right: 0) )
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: leftFrame, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: rightFrame, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
        createEventView(toView: self.backgroundView!)
    }
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
}

extension DIYFSCalendarCell {
    func theme(_ theme: MyTheme) {
        self.themeBackgroundColor = theme.settings.backgroundColor
        self.selectionBackgroundColor = theme.settings.borderColor
        self.themeSecondaryBackgroundColor = theme.settings.secondaryBackgroundColor
        self.contrastColor = theme.settings.contrastColor1
        self.borderColor = theme.settings.borderColor
        
    }
}
