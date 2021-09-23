//
//  EnlargeSecondTableViewCell.swift
//  CashApp
//
//  Created by Артур on 2.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer
class SecondTableViewCell: UITableViewCell  {
    
    
    
    var delegate: SendEnlargeIndex!
    var object = Int()
    let themeManager = ThemeManager2.currentTheme()
    
    var titleLabel: TitleLabel = {
        let label = TitleLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .regular)
        
        return label
    }()
    
    var subTitleLabel: SubTitleLabel = {
        let label = SubTitleLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    
    var sumLabel: TitleLabel = {
        let label = TitleLabel(frame: .zero)
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var editButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var lineView: UIView!
    //    var lineView: UIView = {
    //       let view = UIView()
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        return view
    //    }()
    var object2 = Int()
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lineView.isHidden = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func checkTheAccount(accountID: String) -> String {
        var accountIdentifier: String?
        for i in accountsObjects {
            if accountID == i.accountID {
                accountIdentifier = i.name
            }
        }
        return accountIdentifier ?? "Без счета"
    }
    
    func set(object: AccountsHistory, isLast: Bool) {
        titleLabel.text = object.name
        subTitleLabel.text = !object.secondAccountName.isEmpty
            ? object.secondAccountName
            : object.accountName
        //checkTheAccount(accountID: object.accountID)
        sumLabel.text = String(object.sum.currencyFormatter(ISO: object.currencyISO))
        
        if isLast == true {
            lineView.isHidden = true
        }
        guard let image = object.image else {return}
        self.image.image = UIImage(named: image)
        //        drawDottedLine(start: CGPoint(x: lineView.bounds.minX, y: lineView.bounds.minY), end: CGPoint(x: lineView.bounds.maxX, y: lineView.bounds.minY), view: lineView)
        Themer.shared.register(target: self, action: SecondTableViewCell.theme(_:))
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // lineView = SeparatorView(cell: self).createLineView()
        lineView = SeparatorView(cell: self).createLineViewWithConstraints()
        Themer.shared.register(target: self, action: SecondTableViewCell.theme(_:))
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        editButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        createConstraints()
    }
 
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    var closure: (() -> Void)?
    func editHistoryButtonTapped(action: () -> Void) {
        
    }
    
    @objc func pressed() {
        editHistoryButtonTapped(action: closure!)
    }
    func createConstraints() {
        
        self.contentView.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(editButton)
        self.contentView.addSubview(sumLabel)
        self.contentView.addSubview(image)
        
        let rawPriority = UILayoutPriority.defaultLow.rawValue
        let labelPriority = UILayoutPriority(rawPriority + 1)
        
        sumLabel.setContentHuggingPriority(labelPriority, for: .horizontal)
        
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true  //80 (Общая высота ячейки) - 48 (высота изображения) / 2 = 16
        image.heightAnchor.constraint(equalToConstant: 48).isActive = true
        image.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        
        sumLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26).isActive = true
        sumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        sumLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: sumLabel.leadingAnchor).isActive = true
        
        
        
        //  subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        //        var priorityObject = subTitleLabel.trailingAnchor.constraint(equalTo: sumLabel.leadingAnchor)
        
        
        
        //        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //        lineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        //        lineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //        lineView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        editButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -12).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        editButton.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let superCell = superview?.next() as! UITableViewCell
            delegate.enlarge(object: superCell.indexPath!)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SecondTableViewCell {
    func theme(_ theme: MyTheme) {
        //titleLabel.textColor = theme.settings.titleTextColor
        //subTitleLabel.textColor = theme.settings.subtitleTextColor
        //image.setImageColor(color: theme.settings.titleTextColor)
        editButton.backgroundColor = theme.settings.titleTextColor.withAlphaComponent(0.4)
        editButton.setImage(UIImage(named: "edit") , for: .normal)
        image.changePngColorTo(color: theme.settings.titleTextColor)
        lineView.backgroundColor = theme.settings.separatorColor
        
    }
}
protocol SendEnlargeIndex {
    func enlarge(object: IndexPath)
}
extension UIResponder {
    /**
     * Returns the next responder in the responder chain cast to the given type, or
     * if nil, recurses the chain until the next responder is nil or castable.
     */
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        
        let a = self.next
        let b = a?.next
        
        return next.flatMap({ b as? U ?? $0.next() })
    }
    func nextInOne<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return next.flatMap({ $0 as? U ?? $0.next() })
    }
}
extension UITableViewCell {
    var nextTableView: UITableView? {
        return self.nextInOne(of: UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return self.nextTableView?.indexPath(for: self)
        
    }
}
