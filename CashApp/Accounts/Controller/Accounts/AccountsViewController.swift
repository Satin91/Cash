//
//  TotalBalanceSchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 9/29/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar



class AccountsViewController: UIViewController, scrollToNewAccount{
    let colors = AppColors()
    
  
   
    var navBarButtons: NavigationBarButtons!
    lazy var blur = BlurView(frame: self.view.bounds)
    func scrollToNewAccount(account: MonetaryAccount) {
        var indexPathIndex = 0
        accountsCollectionView.reloadData()
        
        for acc in EnumeratedAccounts(array: accountsGroup) {
            if acc.accountID == account.accountID {
                accountsCollectionView.scrollToItem(at: IndexPath(row: indexPathIndex, section: 0), at: .centeredHorizontally, animated: true)
                
            } else {
                indexPathIndex += 1
            }
        }
        
        visibleIndexPath = IndexPath(row: indexPathIndex, section: 0)
        sendNotification(objectAt: IndexPath(row: indexPathIndex, section: 0))
    }
    var willAccountBeMain: Bool?
    
    var imageCollectionView = AccountImagesCollectionView()
    let subscriptionManager = SubscriptionManager()
    var menuTableView: MenuTableView!
    // var stackViewForEditingButtons = UIStackView()
    var alertView: AlertViewController!
    var goldenRatio: CGFloat {
        (self.view.bounds.width - (22 * 2)) * 0.62
    }
    @IBOutlet var sendButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var sendButtonOutlet: UIButton!
    @IBAction func sendButtonAction(_ sender: UIButton) {
        let account = accountsObjects[visibleIndexPath.row]
        let transferModel = TransferModel(account: account, transferType: .send)
        goToQuickPayVC(reloadDelegate: self, PayObject: transferModel)
        
    }
    
    @IBOutlet var receiveButtonOutlet: UIButton!
    @IBAction func receiveButtonAction(_ sender: UIButton) {
        let account = accountsObjects[visibleIndexPath.row]
        let transferModel = TransferModel(account: account, transferType: .receive)
        goToQuickPayVC(reloadDelegate: self, PayObject: transferModel)
    }
    @IBAction func addButton(_ sender: Any) {
        //View subscription view controller if needed
     
    }

    
    @IBOutlet var containerView: UIView!
    
    //var blur: Blur!
    //@IBOutlet var topConstreintOfCollectionView: NSLayoutConstraint!
    @IBOutlet var accountsCollectionView: UICollectionView!
    
    //Buttons outlets
    @IBOutlet var backButtonOutlet: UIBarButtonItem!
    ///Buttons images

    
    func openAddVC() { // Delegate только так работает
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addAccountVC") as! AddAccountViewController
        let navVC = UINavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true, completion: nil)
        addVC.scrollToNewAccountDelegate = self
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard !accountsGroup.isEmpty else {return}
        visibleIndexPath = accountsCollectionView.indexPathsForVisibleItems.first
        sendNotification(objectAt: visibleIndexPath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //sendButtonWidthConstraint.constant
        self.tabBarController?.tabBar.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.loadColors()
        self.setColors()
        setupMenuTableView()
        setupAlertView()
        accountsLayout()
        backButtonOutlet.title = NSLocalizedString("back_button", comment: "")
        setupAccountCollectionView()
        self.view.insertSubview(self.blur, aboveSubview: self.sendButtonOutlet)
        self.view.bringSubviewToFront(accountsCollectionView)
        setupImageCollectionView()
        self.sendButtonWidthConstraint.constant = self.goldenRatio
        title = "Счета"
        
        setupNavBarButtons()
    }
    func setupNavBarButtons() {
        navBarButtons = NavigationBarButtons(navigationItem: navigationItem, leftButton: .back, rightButton: .add)
        navBarButtons.setLeftButtonAction { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        navBarButtons.setRightButtonAction {[weak self] in
            guard let self = self else { return }
            if accountsObjects.count >= self.subscriptionManager.allowedNumberOfCells(objectsCountFor: .accounts) {
                self.showSubscriptionViewController()
            } else {
                self.openAddVC()
            }
        }
    }
    
    // Отправляет уведомления для обновления графика
    func sendNotification(objectAt: IndexPath?) {
        guard let indexPath = objectAt else {return}
        visibleObject = EnumeratedAccounts(array: accountsGroup)[indexPath.row]
        guard let object = visibleObject else { return }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MonetaryAccount"), object: object)
    }
    func setupAlertView(){
        alertView = AlertViewController.loadFromNib()
        alertView.controller = self
    }
    func setupMenuTableView() {
        menuTableView = MenuTableView(frame: .zero , style: .plain, controller: self)
        menuTableView.tappedDelegate = self
    }
    func setupImageCollectionView() {
        imageCollectionView = AccountImagesCollectionView(frame: .zero)
        self.view.addSubview(imageCollectionView)
        imageCollectionView.alpha = 0
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.topAnchor.constraint(equalTo: accountsCollectionView.bottomAnchor,constant: 22).isActive = true
        imageCollectionView.heightAnchor.constraint(equalToConstant: containerView.bounds.height /*accountsCollectionView.bounds.height + 60*/).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -22).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: accountsCollectionView.leadingAnchor,constant: 22).isActive = true
    }
    func hiddenNavigationItems() {
        navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    func setupAccountCollectionView() {
        accountsCollectionView.delegate = self
        accountsCollectionView.dataSource = self
        accountsCollectionView.clipsToBounds = false
        accountsCollectionView.isPagingEnabled = true
        let nib = UINib(nibName: "AccountCollectionViewCell", bundle: nil)
        accountsCollectionView.register(nib, forCellWithReuseIdentifier: AccountCollectionViewCell().identifier)
    }
    
    func accountsLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let edge: CGFloat = 22
        layout.itemSize = CGSize(width: accountsCollectionView.bounds.width - edge*2, height: accountsCollectionView.bounds.height)
        let edgeinsets = UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
        layout.sectionInset = edgeinsets
        layout.minimumLineSpacing = edge * 2
        accountsCollectionView.collectionViewLayout = layout
        
    }
 
    
    var visibleObject:     MonetaryAccount?
    var visibleIndexPath:  IndexPath!
    var selectedIndexPath: IndexPath!
    var editableObject:    MonetaryAccount?
    var editMode = false //Нажата ли кнопка
    
}


//MARK: Collection View
extension AccountsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  accountsObjects.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell().identifier, for: indexPath) as! AccountCollectionViewCell
        let object = accountsObjects[indexPath.row]
        cell.setAccount(account: object)
        cell.lock(object.isBlock)
        cell.closure = { [weak self] (success) in
            guard let self = self else { return}
            if success {
                self.openMenu()
            } else {
                self.closeMenu()
            }
        }
        cell.editMode = self.editMode // Нужно для того, чтобы ячейка не теряла режим редактирования после обновления коллекции
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: accountsCollectionView.contentOffset, size: accountsCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath2 = accountsCollectionView.indexPathForItem(at: visiblePoint)
        guard visibleIndexPath2 != nil else {
            return
        }
        if visibleIndexPath != visibleIndexPath2{ // Проверка на изменения ячейки
            visibleIndexPath = visibleIndexPath2
            sendNotification(objectAt: visibleIndexPath)
        }
        
    }
}
//MARK: Popover DELEGATE
extension AccountsViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
//MARK: ReloadAfterTransfer
extension AccountsViewController: ReloadParentTableView {
    func reloadData() {
        self.accountsCollectionView.reloadData()
    }
}
