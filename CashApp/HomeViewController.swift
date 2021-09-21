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
      
        toggle.toggle()
       
//        guard let sideMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SideMenuVC") as? SideMenuViewController else { return}
//
//        sideMenu.modalPresentationStyle = .overCurrentContext
//        sideMenu.transitioningDelegate = self
//        present(sideMenu, animated: true, completion: nil)
//
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
    
    //MARK: SCROLL EFFECT
    func createMenu()-> UIMenu {
        let action = UIAction(title: "Светлая тема" ) { (Action) in
            Themer.shared.theme = .light
        }
        let actionTwo = UIAction(title: "Темная тема") { (action) in
            Themer.shared.theme = .dark
        }
        let actionThree = UIAction(title: "Купить подписку") { (action) in
        }
        
        let menu = UIMenu(title: "Menu", image: UIImage(named: "AppIcon"), options: .displayInline , children: [action,actionTwo,actionThree])

       return menu
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton = UIBarButtonItem(title: "", image: UIImage(named: "AppIcon"), primaryAction: nil, menu: createMenu())
        navigationItem.leftBarButtonItem = barButton
        Themer.shared.register(target: self, action: HomeViewController.theme(_:))
        
        notifications.sendTodayNotifications()
        installBackgroundView()
        setRightBarButton()
        setLeftBarButtn()
        
        //self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        //totalBalanceButtom.mainButtonTheme()
        tableView.clipsToBounds = true
        networking.getCurrenciesFromJSON(from: .URL)
       // setTotalBalance()
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSizeForHeightBgConstraint(notification: )), name: Notification.Name("TableViewOffsetChanged"), object: nil)
        
//        if NetworkMonitor.shared.isConnected {
//            print("You'r on wifi")
//        }else{
//            print("You're nnot connected")
//        }
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
    
    func setLeftBarButtn() {
        let image = UIImageView(image: UIImage(named: "navigationBarSettings"))
        self.navigationItem.leftBarButtonItem!.image = image.image
        
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
extension HomeViewController {
    func theme(_ theme: MyTheme) {
        
        view.backgroundColor = theme.settings.backgroundColor
    }
}

extension HomeViewController: prepareForMainViewControllers {
    func prepareFor(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
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
