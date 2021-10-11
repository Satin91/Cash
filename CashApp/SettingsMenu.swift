//
//  SettingsMenu.swift
//  CashApp
//
//  Created by Артур on 5.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer
protocol OpenSubscriptionManagerController {
    func openSubscriptionManager()
}
class SettingsMenu: UIView {
    let colors = AppColors()
    var tableView: UITableView!
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style:Themer.shared.theme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight ))
    let isActiveSubscription = UserDefaults.standard.bool(forKey: "isAvailable") // Проверяет активность подписки
    let notificationsTheDayBeforeIsOn = UserDefaults.standard.bool(forKey: "isOnNotifications") //
    var originPoint: CGPoint!
    weak var parentView: UIView!
    var subscriptionDelegate: OpenSubscriptionManagerController!
    var toggle: Bool = Themer.shared.theme == .light ? true : false {
        didSet {
            UIView.animate(withDuration: 0.1) {
                Themer.shared.theme = self.toggle ? .light : .dark
            }
        }
        willSet{
            IsLightTheme.isLightTheme = newValue
        }
    }
    let cellsHeight: [CGFloat] = [
        60,   /*Theme*/
        90,   /*Notification*/
        60]   /*PRO*/
    
    init(frame: CGRect, parentView: UIView, originPoint: CGPoint) {
        super.init(frame: frame)
        colors.loadColors()
        self.parentView = parentView
        self.originPoint = originPoint
        visualEffect.frame = parentView.bounds
        parentView.addSubview(visualEffect)
        visualEffect.alpha = 0
        Themer.shared.register(target: self, action: SettingsMenu.theme(_:))
        tableView = UITableView(frame: self.bounds)
        self.addSubview(tableView)
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 18
        self.layer.cornerCurve = .continuous
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    deinit{
        print("Deinit settings menu")
    }
    
    lazy var totalHeight: CGFloat = {
        var total: CGFloat = 0
        cellsHeight.forEach { cellHeight in
            total += cellHeight
        }
        return total
    }()
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        // self.tableView.frame = self.bounds
        initConstraints(view: tableView, to: self)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.layer.setMiddleShadow(color: .black)
        registerCells()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTableView()
    }
    func changeNotificationsTheDayBeforeIsOn() {
        guard IsAvailableSubscription.isAvailable == true else { return }
        NotificationsTheDayBeforeEvent.isOn.toggle()
    }
    func checkNotificationTheDayBefore(_ cell: UITableViewCell) -> UIListContentConfiguration  {
        var list = cell.defaultContentConfiguration()

        switch IsAvailableSubscription.isAvailable {
        case true:
            list.textProperties.color = colors.titleTextColor
            list.imageProperties.tintColor = colors.titleTextColor
        case false:
            list.textProperties.color = colors.subtitleTextColor
            list.imageProperties.tintColor = colors.subtitleTextColor
        case .none:
            list.textProperties.color = colors.subtitleTextColor
            list.imageProperties.tintColor = colors.subtitleTextColor
        case .some(_):
            list.textProperties.color = colors.subtitleTextColor
            list.imageProperties.tintColor = colors.subtitleTextColor
        }
        return list
    }
    func notificationImage() -> UIImage {
        var image = UIImage(systemName: "bell.slash.fill")!
        
        guard let isOn = NotificationsTheDayBeforeEvent.isOn else { return image }
        
        if isOn {
            image = UIImage(systemName: "bell.badge.fill")!
        } else {
            image = UIImage(systemName: "bell.slash.fill")!
        }
        return image
    }
    
    func registerCells() {
        tableView.register(SettingsThemeTableViewCell.self, forCellReuseIdentifier: "SettingsThemeTableViewCell")
        tableView.register(SettingsNotificationTableViewCell.self, forCellReuseIdentifier: "SettingsNotificationTableViewCell")
        tableView.register(SettingsSubscriptionTableViewCell.self, forCellReuseIdentifier: "SettingsSubscriptionTableViewCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SettingsMenu: UITableViewDelegate, UITableViewDataSource {
    func clearCellBackground(_ cell: UITableViewCell) {
        cell.contentView.backgroundColor = .clear
        cell.backgroundView?.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    //MARK: - Theme cell
    func configureThemeTableViewCell(_ cell: UITableViewCell){
        var config = cell.defaultContentConfiguration()
        let image = Themer.shared.theme == .dark ? "moon.fill" : "sun.min.fill"
        let themeText: String = Themer.shared.theme == .dark ? "dark_theme_style" : "light_theme_style"
        config.text = NSLocalizedString(themeText, comment: "")
        config.textProperties.numberOfLines = 0
        config.textProperties.color = colors.titleTextColor
        config.secondaryTextProperties.color = colors.subtitleTextColor
        config.textProperties.adjustsFontSizeToFitWidth = true
        config.textToSecondaryTextVerticalPadding = 5
        config.image = UIImage(systemName: image)
        config.imageProperties.tintColor = colors.titleTextColor
        config.imageProperties.reservedLayoutSize = CGSize(width: 26, height: 26)
        cell.contentConfiguration = config
    }
    //MARK: - Notification cell
    func configureNotificationTableViewCell(_ cell: UITableViewCell){
        var config = checkNotificationTheDayBefore(cell)
        let themeText: String = "notify_about_the_plan_one_day_before"
        config.text = NSLocalizedString(themeText, comment: "")
        config.textProperties.numberOfLines = 0
        config.textProperties.adjustsFontSizeToFitWidth = true
        config.textToSecondaryTextVerticalPadding = 5
        config.image = self.notificationImage()
        config.imageProperties.reservedLayoutSize = CGSize(width: 26, height: 26)
        cell.contentConfiguration = config
    }
    //MARK: - Subscription cell
    func configureSubscriptionViewCell(_ cell: UITableViewCell){
        var config = cell.defaultContentConfiguration()
        let image = "crown.fill"
        let themeText: String = "pro_version"
        let secondaryText = self.isActiveSubscription ? "pro_is_active": "pro_is_not_active"
        config.text = NSLocalizedString(themeText, comment: "")
        config.textProperties.numberOfLines = 0
        config.textProperties.color = colors.titleTextColor
        config.secondaryTextProperties.color = colors.subtitleTextColor
        config.secondaryTextProperties.color = self.isActiveSubscription ? self.colors.contrastColor1 : self.colors.subtitleTextColor
        config.secondaryText = NSLocalizedString(secondaryText, comment: "")
        config.textProperties.adjustsFontSizeToFitWidth = true
        config.textToSecondaryTextVerticalPadding = 5
        config.image = UIImage(systemName: image)
        config.imageProperties.tintColor = colors.titleTextColor
        config.imageProperties.reservedLayoutSize = CGSize(width: 26, height: 26)
        cell.contentConfiguration = config
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsThemeTableViewCell", for: indexPath)
            self.clearCellBackground(cell)
            configureThemeTableViewCell(cell)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsNotificationTableViewCell", for: indexPath)
            self.clearCellBackground(cell)
            configureNotificationTableViewCell(cell)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSubscriptionTableViewCell", for: indexPath)
            self.clearCellBackground(cell)
            configureSubscriptionViewCell(cell)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        for (index,value) in cellsHeight.enumerated() {
            if indexPath.row == index {
                return value
            }
        }
        return CGFloat()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.toggle.toggle()
            tableView.reloadData()
        case 1:
            changeNotificationsTheDayBeforeIsOn()
            tableView.reloadData()
        case 2:
            subscriptionDelegate.openSubscriptionManager()
        default:
            break
        }
    }
}
extension SettingsMenu {
    func theme(_ theme: MyTheme) {
        self.backgroundColor = theme.settings.secondaryBackgroundColor
    }
}
