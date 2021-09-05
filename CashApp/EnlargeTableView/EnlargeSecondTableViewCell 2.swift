//
//  EnlargeSecondTableViewCell.swift
//  CashApp
//
//  Created by Артур on 2.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    
    var delegate: SendEnlargeIndex!
    var object = Int()
    let themeManager = ThemeManager.currentTheme()
    
    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.textColor = ThemeManager.currentTheme().titleTextColor
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = ThemeManager.currentTheme().subtitleTextColor
        return label
    }()
    
    
    var sumLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeManager.currentTheme().titleTextColor
        return label
    }()
    
    var sendButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        return button
    }()
    
    var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var lineView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var object2 = Int()
    override func prepareForReuse() {
        super.prepareForReuse()
        lineView.isHidden = false
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
        subTitleLabel.text = checkTheAccount(accountID: object.accountID)
        sumLabel.text = String(object.sum.currencyFormatter(ISO: object.currencyISO))
        image.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
        if isLast == true {
            lineView.isHidden = true
        }
        guard let image = object.image else {return}
        self.image.image = UIImage(named: image)
        
        
    }
    func setColors(){
        lineView.backgroundColor = themeManager.separatorColor
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.awakeFromNib()
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        sendButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        setColors()
        createConstraints()
    }
    
    @objc func pressed() {
    }
    func createConstraints() {
        
        self.contentView.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(sendButton)
        self.contentView.addSubview(sumLabel)
        self.contentView.addSubview(image)
        
        let rawPriority = UILayoutPriority.defaultLow.rawValue
        let labelPriority = UILayoutPriority(rawPriority + 1)
        
        sumLabel.setContentHuggingPriority(labelPriority, for: .horizontal)
        
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true  //80 (Общая высота ячейки) - 48 (высота изображения) / 2 = 16
        image.heightAnchor.constraint(equalToConstant: 48).isActive = true
        image.widthAnchor.constraint(equalToConstant: 48).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        
        sumLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26).isActive = true
        sumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        sumLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true

        subTitleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: sumLabel.leadingAnchor).isActive = true
        
        
        
      //  subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
//        var priorityObject = subTitleLabel.trailingAnchor.constraint(equalTo: sumLabel.leadingAnchor)
        
        

        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
        
        sendButton.isHidden = true
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
