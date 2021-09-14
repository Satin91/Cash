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

    func scrollToNewAccount(account: MonetaryAccount) {
        var indexPathIndex = 0
        accountsCollectionView.reloadData()
        
        for i in EnumeratedAccounts(array: accountsGroup) {
            if i.accountID == account.accountID {
                accountsCollectionView.scrollToItem(at: IndexPath(row: indexPathIndex, section: 0), at: .centeredHorizontally, animated: true)
                
            }else{
            indexPathIndex += 1
            }
        }
        
        visibleIndexPath = IndexPath(row: indexPathIndex, section: 0)
        sendNotification(objectAt: IndexPath(row: indexPathIndex, section: 0))
    }
    
    var imageCollectionView = AccountImagesCollectionView()
    var menu: InstallMenuTableView!
    
    var stackViewForEditingButtons = UIStackView()
    @IBAction func addButton(_ sender: Any) {
       // gotoNextVC()
        openAddVC()
    }
    let alertView = AlertViewController()
    @IBOutlet var containerView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    //var blur: Blur!
    //@IBOutlet var topConstreintOfCollectionView: NSLayoutConstraint!
    @IBOutlet var accountsCollectionView: UICollectionView!
    
    //Buttons outlets
    @IBOutlet var backButtonOutlet: UIBarButtonItem!
    var editingButtons = EditingButtons()
    ///Buttons images
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
    }

    func openAddVC() { // Delegate только так работает
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addAccountVC") as! AddAccountViewController
        let navVC = UINavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true, completion: nil)
        addVC.scrollToNewAccountDelegate = self
        
    }
    
    //Отправляет уведомления для обновления графика
    func sendNotification(objectAt: IndexPath?) {
        guard let indexPath = objectAt else {return}
        
        visibleObject = EnumeratedAccounts(array: accountsGroup)[indexPath.row]
        
        guard let Object = visibleObject else{return}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MonetaryAccount"), object: Object)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard accountsGroup.count != 0 else {return}
        visibleIndexPath = accountsCollectionView.indexPathsForVisibleItems.first
        sendNotification(objectAt: visibleIndexPath)
        
      //  accountsCollectionView.reloadData() // Обновляем после добавления нового аккаунта
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        self.tabBarController?.tabBar.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
    
    @objc func openAddController(_ sender: UIButton){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.loadColors()
        self.setColors()
        accountsLayout()
        menu = InstallMenuTableView(owner: self)
        
        backButtonOutlet.title = NSLocalizedString("back_button", comment: "")
        setupAccountCollectionView()
        let nib = UINib(nibName: "AccountCollectionViewCell", bundle: nil)
        accountsCollectionView.register(nib, forCellWithReuseIdentifier: AccountCollectionViewCell().identifier)
        blurView.frame = self.view.bounds
        
        
        self.view.insertSubview(self.blurView, at: 9)
        self.view.bringSubviewToFront(accountsCollectionView)
        blurView.layer.opacity = 0
        setupImageCollectionView()
        
    }
    
    func setupImageCollectionView() {
        imageCollectionView = AccountImagesCollectionView(frame: .zero)
        imageCollectionView.delegate = self
        self.view.addSubview(imageCollectionView)
        imageCollectionView.alpha = 0
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.topAnchor.constraint(equalTo: accountsCollectionView.bottomAnchor,constant: 26).isActive = true
        imageCollectionView.heightAnchor.constraint(equalToConstant: accountsCollectionView.bounds.height + 60).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: accountsCollectionView.leadingAnchor,constant: 26).isActive = true
        
    }
    func hiddenNavigationItems() {
        navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addAccountSegue" {
//            if let nextViewController = segue.destination as? AddAccountViewController {
//                nextViewController.scrollToNewAccountDelegate = self
//            }
//        }
//    }
    
    func setupAccountCollectionView() {
        accountsCollectionView.delegate = self
        accountsCollectionView.dataSource = self
        
        accountsCollectionView.isPagingEnabled = true
    }
    
    func accountsLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let edge: CGFloat = 26
        layout.itemSize = CGSize(width: accountsCollectionView.bounds.width - edge*2, height: accountsCollectionView.bounds.height)
        let edgeinsets = UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
        layout.sectionInset = edgeinsets
        layout.minimumLineSpacing = edge * 2
        accountsCollectionView.collectionViewLayout = layout
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    var visibleObject:     MonetaryAccount?
    var visibleIndexPath:  IndexPath!
    var selectedIndexPath: IndexPath!
    var editableObject:    MonetaryAccount?
    var toggle = false //Нажата ли кнопка
    
//    func changeConstraint() {
//        if topConstreintOfCollectionView.constant == 14{
//
//            UIView.animate(withDuration: 0.6) {
//                self.blurView.layer.opacity = 1
//                //self.view.layoutIfNeeded()
//              //  self.topConstreintOfCollectionView.constant = 250
//                self.view.layoutIfNeeded()
//            }
//
//            self.view.bringSubviewToFront(accountsCollectionView)// Для того чтобы графики не перекрывали карту
//            self.accountsCollectionView.reloadData()
//            goToImageIndex()
//        }else{
//
//            UIView.animate(withDuration: 0.6) {
//                self.blurView.layer.opacity = 0
//                //self.view.layoutIfNeeded()
//                self.topConstreintOfCollectionView.constant = 14
//                self.view.layoutIfNeeded()
//                self.selectedObject = nil
//            }
//
//            self.accountsCollectionView.reloadData()
//            backToIndex()
//        }
//    }
//
//    func backToIndex() {
//        accountsCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
//    }
//
//    func goToImageIndex() {
//        var imageIndex = IndexPath(row: 0, section: 0)
//        for (index,value) in accountsImages.enumerated() {
//            if selectedObject?.imageForAccount == value {
//                imageIndex.row = index
//            }
//        }
//        //Непонятно почему, но при анимировании скролится в пустоту
//        accountsCollectionView.scrollToItem(at: imageIndex, at: .centeredHorizontally, animated: false)
//        visibleIndexPath = imageIndex // В момент загрузки новых ячеек видимый индекс равен nil, по этому видемый индекс равен индексу текущего изображения
//    }
    
    }


//MARK: Collection View
extension AccountsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //(selectedObject != nil) ? accountsImages.count :
        return  accountsObjects.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell().identifier , for: indexPath) as! AccountCollectionViewCell
        cell.delegate = self
        if editableObject != nil {
            let object = editableObject
            //cell.setForSelect(image: images!, name: object!.name, balance: String(object!.balance), account: object!)
            cell.setForSelect(image: UIImage(named:object!.imageForAccount)!, name: object!.name, balance: String(object!.balance), account: object!)
            cell.delegate = self
            //Установил наблюдатель иммено здесь потому что нужно чтобы он действовал на все выводимые ячейки, а не на единственную как было бы, если б установил это в протоколе нажатия на кнопку
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":true])
            return cell
        }else{
        let object = accountsObjects[indexPath.row]
            cell.setAccount(account: object)
            cell.delegate = self
            //Установил наблюдатель иммено здесь потому что нужно чтобы он действовал на все выводимые ячейки, а не на единственную как было бы, если б установил это в протоколе нажатия на кнопку
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil, userInfo: ["CASE":false])
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //accountsCollectionView.reloadData()
        
        
        accountsCollectionView.reloadData()
        let visibleRect = CGRect(origin: accountsCollectionView.contentOffset, size: accountsCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath2 = accountsCollectionView.indexPathForItem(at: visiblePoint)
        guard visibleIndexPath2 != nil else {
            return
        }
        if visibleIndexPath != visibleIndexPath2{ // Проверка на изменения ячейки
            visibleIndexPath = visibleIndexPath2
            guard editableObject == nil else {return} // Запрещает отправлять уведомления когда выбран объект для редактирования
            sendNotification(objectAt: visibleIndexPath)
        }
        
//        let visibleRect = CGRect(origin: accountsCollectionView.contentOffset, size: accountsCollectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        let visibleIndexPath2 = accountsCollectionView.indexPathForItem(at: visiblePoint)
//
//        guard visibleIndexPath2 != nil else {
//            return
//        }
//        visibleIndexPath = visibleIndexPath2
//
//        if visibleIndexPath != visibleIndexPath2{ // Проверка на изменения ячейки
//            visibleIndexPath = visibleIndexPath2
//            print(editableObject)
//            guard editableObject == nil else {return} // Запрещает отправлять уведомления когда выбран объект для редактирования
//            sendNotification(objectAt: visibleIndexPath)
//        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       //Классная функция. Применяется когда скрол останавливается
    }
        
}
//MARK: Popover DELEGATE
extension AccountsViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}



extension AccountsViewController: ActionsWithAccount {
    func actionsWithAccount() {
        
        self.accountsCollectionView.reloadData()
    }
    
    
    
}
