//
//  OperationViewController.swift
//  CashApp
//
//  Created by Артур on 9/10/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift



class OperationViewController: UIViewController, UITextFieldDelegate, dismissVC {
    
    
    
    
    func dismissVC(goingTo: String, typeIdentifier: String) { // Вызывается после подтверждения выбора в addVc
        
        let addCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addCategoryVC") as! AddOperationViewController
        if goingTo == "addCategoryVC" {
            switch typeIdentifier {
            case "Income":
                addCategoryVC.newCategoryObject.stringEntityType = .income
            case "Expence":
                addCategoryVC.newCategoryObject.stringEntityType = .expence
            default:
                return
            }
        }
        addCategoryVC.tableReloadDelegate = self
        let navVC = UINavigationController(rootViewController: addCategoryVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true, completion: nil)
    }
    
    
    var popViewController: UIViewController! // Child View Controller
    var changeValue = true
    var pressedIndexPath: IndexPath?
    ///             Outlets:
    @IBOutlet var segmentedControl: HBSegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    ///            Actions:
    @IBAction func actionSegmentedControl(_ sender: HBSegmentedControl) {
        sender.changeSegmentWithAnimation(tableView: nil, collectionView: collectionView, ChangeValue: &changeValue)
    }
    ///             POPUP VIEW
    @IBOutlet var blurView: UIVisualEffectView!
    ///             ACTIONS
    
    func goToAddOperationVC() {
        let pickTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpTableViewController
        pickTypeVC.cellNames = ["Income","Expence"]
        pickTypeVC.goingTo = "addCategoryVC"
        pickTypeVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: pickTypeVC)
        navVC.modalPresentationStyle = .popover
        let popVC = navVC.popoverPresentationController
        popVC?.delegate = self
        let barButtonView = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
        popVC?.sourceView = barButtonView
        popVC?.sourceRect = barButtonView!.bounds
        pickTypeVC.preferredContentSize = CGSize(width: 200, height: pickTypeVC.cellNames.count * 50)
        present(navVC, animated: true, completion: nil)
        // Передача данных описана в классе PickTypePopUpViewController
        guard popViewController != nil else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
            self.closeChildViewController()
        })
    }
    @IBAction func addButton(_ sender: Any) {
        //addVC
        let pickTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpTableViewController
        pickTypeVC.cellNames = ["Income","Expence"]
        pickTypeVC.goingTo = "addCategoryVC"
        pickTypeVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: pickTypeVC)
        navVC.modalPresentationStyle = .popover
        let popVC = navVC.popoverPresentationController
        popVC?.delegate = self
        let barButtonView = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
        popVC?.sourceView = barButtonView
        popVC?.sourceRect = barButtonView!.bounds
        pickTypeVC.preferredContentSize = CGSize(width: 200, height: pickTypeVC.cellNames.count * 50)
        present(navVC, animated: true, completion: nil)
        // Передача данных описана в классе PickTypePopUpViewController
        guard popViewController != nil else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
            self.closeChildViewController()
        })
    }
    func visualSettings() {
        let theme = ThemeManager.currentTheme()
        self.view.backgroundColor = theme.backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
        
        self.tabBarController?.tabBar.showTabBar()
        print("operationview did appear operationVC")
        //При переходе через таб бар обновления не происходят
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.changeValuesForCashApp(segmentOne: "Expence", segmentTwo: "Income")
        setupNavigationController(Navigation: navigationController!)
        blurView.bounds = self.view.frame
        self.view.backgroundColor = whiteThemeBackground
        setupCollectionView()
        visualSettings()
        
    }
    
    //wait for Figma 
    func classColor() {
        self.view.backgroundColor = whiteThemeBackground
    }
    
    
    
    //MARK: Add/Delete Child View Controller
    func addChildViewController(PayObject: MonetaryCategory) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let QuiclPayVC = storyboard.instantiateViewController(withIdentifier: "QuickPayVC") as! QuickPayViewController
        QuiclPayVC.payObject = PayObject
        
        QuiclPayVC.closePopUpMenuDelegate = self //Почему то работает делегат только если кастить до popupviiewController'a
        // Проверка для того чтобы каждый раз не добавлять viewController при его открытии
        
        if popViewController == nil {
            popViewController = QuiclPayVC
            popViewController.view.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.55)
            popViewController.view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            self.addChild(popViewController) // Не знаю зачем это, надо удалить без него тоже работает
            self.view.animateViewWithBlur(animatedView: blurView, parentView: self.view)
            view.animateViewWithBlur(animatedView: popViewController.view, parentView: self.view)
            popViewController.didMove(toParent: self)
        }
    }
    
    func closeChildViewController() {
        self.view.reservedAnimateView(animatedView: popViewController.view, viewController: popViewController)
        popViewController = nil // Это нужно для того, чтобы снова его открыть. Потому что в открытии стоит условие
        self.view.reservedAnimateView(animatedView: blurView, viewController: nil)
        
    }
    
}





//MARK: Collectiom view delegate dataSource
extension OperationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = changeValue ? Array(expenceObjects).count: Array(incomeObjects).count
        switch changeValue {
        case true:
            count = Array(expenceObjects).count > 0 ? Array(expenceObjects).count + 1: 1
        case false:
            count = Array(incomeObjects).count > 0 ? Array(incomeObjects).count + 1: 1
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell2: CreateOperationCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateOperationCell.identifier, for: indexPath) as! CreateOperationCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OperationCell", for: indexPath) as! OperationCell
        
        // let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CreateOperationCell.identifier, for: indexPath) as! CreateOperationCell
        switch changeValue {
        case true:
            if indexPath.row == expenceObjects.count {
                return cell2
            }else{
                let object = expenceObjects[indexPath.row]
                cell.set(object: object)
            }
        case false :
            if indexPath.row == incomeObjects.count {
                return cell2
            }else{
                let object = incomeObjects[indexPath.row]
                cell.set(object: object)
                return cell
            }
        }
        return cell
    }
    
    private func createNewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 3.0, leading: 3.0, bottom: 3.0, trailing: 3.0)
            
            let subGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(2/5)), subitem: trailingItem, count: 3)
            subGroup.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: subGroup, count: 4)
            trailingGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 26)
            let section = NSCollectionLayoutSection(group: trailingGroup)
            
            section.orthogonalScrollingBehavior = .paging
            return section
        }
        
        return layout
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        switch changeValue {
        case true:
            if indexPath.row != expenceObjects.count {
                let cell =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                addChildViewController(PayObject: cell)
            }else{
                goToAddVC()
            }
        case false:
            if indexPath.row != incomeObjects.count {
                let cell =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                addChildViewController(PayObject: cell)
            }else{
                goToAddVC()
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        
        let press = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: press) {
            
           //отмена нажатия если нажата кнопка добавить
            switch changeValue {
            case true:
                guard indexPath.row != expenceObjects.count else {return}
            case false:
                guard indexPath.row != incomeObjects.count else {return}
            }
            
            if gesture.state == .began {
                let cell = collectionView.cellForItem(at: indexPath)
                pressedIndexPath = indexPath
                goToPopUpTableView(delegateController: self, payObject: [indexPath], sourseView: cell!)
            }
        }
    }
    
    func setupCollectionView() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = createNewLayout()
        collectionView.addGestureRecognizer(gesture)
        collectionView.register(OperationCell.nib(), forCellWithReuseIdentifier: "OperationCell")
        collectionView.register(CreateOperationCell.nib(), forCellWithReuseIdentifier: CreateOperationCell.identifier)
        
    }
    
}


extension OperationViewController: ReloadParentTableView {
    func reloadData() {
        collectionView.reloadData()
    }
}



extension OperationViewController: QuickPayCloseProtocol {
    
    func closePopUpMenu() {
        closeChildViewController()
        collectionView.reloadData()
    }
    
}

extension OperationViewController: ClosePopUpTableViewProtocol {
    
    func goToAddVC(){
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addCategoryVC") as! AddOperationViewController
        addVC.tableReloadDelegate = self
        let navVC = UINavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = .pageSheet
        self.present(navVC, animated: true, completion: nil)
        //addVC.newCategoryObject = object
    }
    
    func closeTableView(object: Any) {
        let object = object as! [String: IndexPath]
        let index = object.values.first
        switch object.keys.first {
        case "Edit":
            print("Edit")
            
        case "Delete":
            switch changeValue {
            case true:
                collectionView.deleteItems(at: [index!])
                try! realm.write({
                    realm.delete(expenceObjects[index!.row])
                })
                self.collectionView.reloadData()
            case false:
                
                collectionView.deleteItems(at: [index!])
                try! realm.write({
                    realm.delete(incomeObjects[index!.row])
                })
                collectionView.reloadData()
            }
        default:
            break
        }
        
        
    }
    
}

extension OperationViewController: UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

