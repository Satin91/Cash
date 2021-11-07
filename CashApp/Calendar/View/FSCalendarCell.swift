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
    override func layoutSubviews() {
        super.layoutSubviews()
        setSelectionLayer()
    }
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundView?.backgroundColor = themeBackgroundColor
        //self.eventView.isHidden = true
        self.selectionLayer.isHidden = true
    }
    override init!(frame: CGRect) {
        super.init(frame: frame)
        Themer.shared.register(target: self, action: DIYFSCalendarCell.theme(_:))
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = self.selectionBackgroundColor.withAlphaComponent(0.2).cgColor
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
        
      //  setSelectionLayer()
    }
 
    func setStyle(cellStyle: CellStyle) {
        switch cellStyle {
        case .DIYCalendar :
            backgroundView?.backgroundColor = themeBackgroundColor.withAlphaComponent(0.8)
        case .defaultCalendar:
            backgroundView?.backgroundColor = themeSecondaryBackgroundColor.withAlphaComponent(0.8)
        }
    }
    let duration = 1

    func createEventView(toView: UIView){
        let side: CGFloat = 4
        let width = toView.bounds.width - side * 2
        let height = toView.bounds.height / 15
        self.eventView.frame = CGRect(x: side, y: toView.bounds.height - height - (side) , width: width, height: height)
        self.eventView.layer.cornerRadius = self.eventView.bounds.height / 4
        self.eventView.backgroundColor = contrastColor
    //
        
    }
    func setSelectionLayer() {
        
        let selectionInset: CGFloat = 6
        //self.eventView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height / 5)
        self.backgroundView?.frame = self.bounds.inset(by: UIEdgeInsets(top: selectionInset, left: 4, bottom: 4, right: 4))
        createEventView(toView: self.backgroundView!)
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
        self.selectionBackgroundColor = theme.settings.titleTextColor
        self.themeSecondaryBackgroundColor = theme.settings.secondaryBackgroundColor
        self.contrastColor = theme.settings.contrastColor1
        self.borderColor = theme.settings.borderColor
        
    }
}
