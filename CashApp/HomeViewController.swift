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



class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate  {
    
    var miniAlert: MiniAlertView!
    let transition = SideInTransition()
    var alertView: MiniAlertView!
    let navBar = setupNavigationBar()
    var toggle: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                Themer.shared.theme = self.toggle ? .dark : .light
                self.navBar.setColors()
            }
        }
    }
    @IBAction func settingsButtonAction(_ sender: UIBarButtonItem) {
        miniAlert.showMiniAlert(message: "Тема поменялась", alertStyle: .success)
        //ThemeManager.theme = DarkTheme()
        //ThemeManager.applyTheme(theme: .dark)
      
       // toggle.toggle()
   

    }
    
    let colors = AppColors()
    let notifications = Notifications()
    //label который сверху (бывш. Total balance)
    @IBOutlet var primaryLabel: UILabel!
    //собсна баланс
    @IBOutlet var balanceLabel: UILabel!
    //собсна кнопка для показывания счетов
    @IBOutlet var totalBalanceButtom: UIButton!
    @IBOutlet var tableView: EnlargeTableView!
    
    @IBOutlet var testLabel: UILabel!
    let networking = Networking()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        miniAlert = MiniAlertView.loadFromNib()
        miniAlert.controller = self
        
        getCurrenciesByPriorities()//Обновить данные об изменении главной валюты
       // setTotalBalance() //Назначить сумму
        setRightBarButton()
        tableView.enterHistoryData() // Обновление данных истории
        tableView.reloadData()
        self.reloadInputViews()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
//    //MARK: SCROLL EFFECT
//    func createMenu()-> UIMenu {
//        let action = UIAction(title: "Светлая тема" ) { (Action) in
//            Themer.shared.theme = .light
//        }
//        let actionTwo = UIAction(title: "Темная тема") { (action) in
//            Themer.shared.theme = .dark
//        }
//        let actionThree = UIAction(title: "Купить подписку") { (action) in
//            let open = OpenNextController(storyBoardID: "SubscriptionsManager", fromViewController: self, toViewControllerID: "SubscriptionsManager", toViewController: SubscriptionsManagerViewController())
//            open.makeTheTransition()
//        }
//
//        let menu = UIMenu(title: "Menu", image: UIImage(named: "AppIcon"), options: .displayInline , children: [action,actionTwo,actionThree])
//       return menu
//    }
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .popover
//    }
    
    func createMenuFromViewController() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Themer.shared.register(target: self, action: HomeViewController.theme(_:))
        notifications.sendTodayNotifications()
        installBackgroundView()
        setRightBarButton()
        setLeftBarButtn()
        
        //self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        //totalBalanceButtom.mainButtonTheme()
        setupTableView()
      //  networking.getCurrenciesFromJSON(from: .URL)
       // setTotalBalance()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSizeForHeightBgConstraint(notification: )), name: Notification.Name("TableViewOffsetChanged"), object: nil)
        
//        if NetworkMonitor.shared.isConnected {
//            print("You'r on wifi")
//        }else{
//            print("You're nnot connected")
//        }
    }
    func setupTableView() {
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.editHistoryObjectDelegate = self
    }
    @objc func changeSizeForHeightBgConstraint(notification: Notification) {
        let object = notification.object as! CGPoint
        
        let heightRange = 120...300
        let sideDistanceRange = 0...26
        let newobj = -object.y
        let sideDistance: CGFloat = 0.26
        let persent =  CGFloat(Int(newobj * 100) / heightRange.max()! )
        let sidePosition = sideDistance * persent
        if sideDistanceRange.contains(Int(sidePosition)) {
           
        }
        //backgroundView.bounds.size.height = newobj
        //let nvHeight = (navigationController?.navigationBar.bounds.height)! * 2
    }
    @objc func leftBarButtonTapped(_ gesture: UITapGestureRecognizer) {
         guard let sideMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SideMenuVC") as? SideMenuViewController else { return }

         sideMenu.modalPresentationStyle = .custom
        sideMenu.transitioningDelegate = self
        
//        let popVC = sideMenu.popoverPresentationController
//        popVC?.delegate = self
//        popVC?.sourceRect = self.navigationItem.leftBarButtonItem!.customView!.bounds
//        popVC?.sourceView = self.navigationItem.leftBarButtonItem!.customView
        sideMenu.preferredContentSize = CGSize(width: 150, height: 150)
        
         present(sideMenu, animated: true, completion: nil)
    }
    func setLeftBarButtn() {
       
        let image = UIImageView(image: UIImage(named: "navigationBarSettings"))
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(leftBarButtonTapped(_:)))
        
        image.addGestureRecognizer(gesture)
        let barButton = UIBarButtonItem(customView: image)
        
        navigationItem.leftBarButtonItem = barButton
        
        
        //self.navigationItem.leftBarButtonItem!.image = image.image
        
        //self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    func setRightBarButton() {
        navigationItem.title = NSLocalizedString("home_navigation_title", comment: "")
        guard let mainImage = mainCurrency?.ISO else {
            let imgView = UIImageView(image: UIImage(named: "USD"))
            self.navigationItem.rightBarButtonItem?.image = imgView.image
            return
        }
        let imgView = UIImageView(image: UIImage(named: mainImage))
        imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = imgView.image
    }
    
    var header: HeaderView!
    func installBackgroundView() {
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
            self.miniAlert.showMiniAlert(message: "Счет отсутствует", alertStyle: .error)
        }
    }
}
extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresent = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresent = false
        return transition
    }
}
