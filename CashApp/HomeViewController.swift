//
//  ViewController.swift
//  CashApp
//
//  Created by Артур on 7/26/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift
import Themer



class HomeViewController: UIViewController  {
    
    var miniAlert: MiniAlertView!
    let navBar = setupNavigationBar()
    var settingsMenu: SettingsMenu!
    var navBarItems: NavigationBarButtons!
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: Themer.shared.theme == .dark ? .systemThinMaterialDark : .systemUltraThinMaterialLight))
    @IBAction func settingsButtonAction(_ sender: UIBarButtonItem) {
        miniAlert.showMiniAlert(message: "Тема поменялась", alertStyle: .success)
    }
    
    
    let colors = AppColors()
    let notifications = Notifications()
    let controller = CurrencyModelController()
    //label который сверху (бывш. Total balance)
    @IBOutlet var primaryLabel: UILabel!
    //собсна баланс
    @IBOutlet var balanceLabel: UILabel!
    //собсна кнопка для показывания счетов
    @IBOutlet var totalBalanceButtom: UIButton!
    @IBOutlet var tableView: EnlargeTableView!
    
    @IBOutlet var testLabel: UILabel!
    let networking = CurrencyNetworking()
    let purchaseManager = Store()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupBarButtons()

        miniAlert = MiniAlertView.loadFromNib()
        miniAlert.controller = self
        
        getCurrenciesByPriorities()//Обновить данные об изменении главной валюты
        // setTotalBalance() //Назначить сумму
        tableView.enterHistoryData() // Обновление данных истории
        tableView.reloadData()
     //   self.reloadInputViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func installmenu() {
        let menuPoint = CGPoint(x: 40, y: topBarHeight)
        settingsMenu = SettingsMenu(frame: .zero, parentView: self.view, originPoint: menuPoint)
        settingsMenu.subscriptionDelegate = self // Делегат, который открывает экран подписки при нажатии на 3 строку TBView
        settingsMenu.isHidden = true
        settingsMenu.layer.setSmallShadow(color: colors.shadowColor)
        self.view.addSubview(settingsMenu)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
           try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
        } catch {
           print("Failed to delete launch screen cache: \(error)")
        }
        
        Themer.shared.register(target: self, action: HomeViewController.theme(_:))
        notifications.sendNotifications()
        installHeaderView()
        installmenu()
        setupTableView()
        navigationItem.title = NSLocalizedString("home_navigation_title", comment: "")
    }
   
    func setupBarButtons() {
        self.navBarItems = NavigationBarButtons(navigationItem: navigationItem, leftButton: .settings, rightButton: .currency)
        self.navBarItems.setLeftButtonAction { [weak self] in
            guard let self = self else { return }
            self.settingsMenu.openOrCloseSettingsMenu(isTappedMenuAnyTime: &self.isTappedMenuAnyTime)
        }
        self.navBarItems.setRightButtonAction {
            self.goToCurrencyVC()
        }
    }
    func goToCurrencyVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "currencyVC") as! CurrencyViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTableView() {
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.editHistoryObjectDelegate = self
    }
    func addmenuToView() {
        
    }
    var isTappedMenuAnyTime: Bool = false
    var header: HeaderView!
    func installHeaderView() {
        header = HeaderView()
        
        header.delegate = self
        self.addChild(header)
        self.view.addSubview(header.view)
        tableView.header = header
        //top bar extension described in anyOption
        tableView.topBarHeight = topBarHeight
    }
}
//MARK: - Theme
extension HomeViewController {
    func theme(_ theme: MyTheme) {
        view.backgroundColor = theme.settings.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.settings.titleTextColor]
        
    }
}

//MARK: - Push account / today balance View Controller
extension HomeViewController: prepareForMainViewControllers {
    func prepareFor(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
//MARK: - EditHistoryObject
extension HomeViewController: EditHistoryObject, ReloadParentTableView {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    func editObject(historyObject: AccountsHistory) {
        if accountsObjects.contains(where: { account in
            historyObject.accountID == account.accountID || historyObject.categoryID.isEmpty == false || historyObject.scheduleID.isEmpty == false
        }) {
            self.goToQuickPayVC(reloadDelegate: self, PayObject: historyObject)
        } else {
            let message = NSLocalizedString("no_account", comment: "")
            self.miniAlert.showMiniAlert(message: message, alertStyle: .error)
        }
    }
}

extension HomeViewController: OpenSubscriptionManagerController {
    func openSubscriptionManager() {
        
        if SubscribtionStatus.isAvailable {
            let message = NSLocalizedString("subscribtion_is_active", comment: "")
            self.miniAlert.showMiniAlert(message: message, alertStyle: .success)
           
        } else {
            // Close settings menu
            self.settingsMenu.openOrCloseSettingsMenu(isTappedMenuAnyTime: &isTappedMenuAnyTime)
            
            // Open SubscriptionManager
            self.showSubscriptionViewController()
        }
        
        
      
    }
}
