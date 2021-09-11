//
//  OperationViewController.swift
//  CashApp
//
//  Created by Артур on 9/10/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift
import Themer


class CategoriesViewController: UIViewController, UITextFieldDelegate {
    
    
//
//
//    func dismissVC(goingTo: String, typeIdentifier: String) { // Вызывается после подтверждения выбора в addVc
//
//        let addCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addCategoryVC") as! AddOperationViewController
//        if goingTo == "addCategoryVC" {
//            switch typeIdentifier {
//            case "Income":
//                addCategoryVC.newCategoryObject.stringEntityType = .income
//            case "Expence":
//                addCategoryVC.newCategoryObject.stringEntityType = .expence
//            default:
//                return
//            }
//        }
//        addCategoryVC.tableReloadDelegate = self
//        let navVC = UINavigationController(rootViewController: addCategoryVC)
//        navVC.modalPresentationStyle = .automatic
//        present(navVC, animated: true, completion: nil)
//    }
    
    
    private var popViewController: UIViewController! // Child View Controller
    private var changeValue = true
    private var pressedIndexPath: IndexPath?
    ///             Outlets:
    @IBOutlet var segmentedControl: HBSegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    ///            Actions:
    @IBAction func actionSegmentedControl(_ sender: HBSegmentedControl) {
        sender.changeSegmentWithAnimation(tableView: nil, collectionView: collectionView, ChangeValue: &changeValue)
    }
    ///             POPUP VIEW
    @IBOutlet var blurView: UIVisualEffectView! // не используется влом удалять пока
    ///             ACTIONS
    
//    func goToAddOperationVC() {
//        let pickTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpTableViewController
//        pickTypeVC.cellNames = ["Income","Expence"]
//        pickTypeVC.goingTo = "addCategoryVC"
//        pickTypeVC.delegate = self
//
//        let navVC = UINavigationController(rootViewController: pickTypeVC)
//        navVC.modalPresentationStyle = .popover
//        let popVC = navVC.popoverPresentationController
//        popVC?.delegate = self
//        let barButtonView = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
//        popVC?.sourceView = barButtonView
//        popVC?.sourceRect = barButtonView!.bounds
//        pickTypeVC.preferredContentSize = CGSize(width: 200, height: pickTypeVC.cellNames.count * 50)
//        present(navVC, animated: true, completion: nil)
//        // Передача данных описана в классе PickTypePopUpViewController
//        guard popViewController != nil else {return}
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
//            self.closeChildViewController()
//        })
//    }
//    @IBAction func addButton(_ sender: Any) {
//        //addVC
//        let pickTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpTableViewController
//        pickTypeVC.cellNames = ["Income","Expence"]
//        pickTypeVC.goingTo = "addCategoryVC"
//
//
//        let navVC = UINavigationController(rootViewController: pickTypeVC)
//        navVC.modalPresentationStyle = .popover
//        let popVC = navVC.popoverPresentationController
//        popVC?.delegate = self
//        let barButtonView = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
//        popVC?.sourceView = barButtonView
//        popVC?.sourceRect = barButtonView!.bounds
//        pickTypeVC.preferredContentSize = CGSize(width: 200, height: pickTypeVC.cellNames.count * 50)
//        present(navVC, animated: true, completion: nil)
//        // Передача данных описана в классе PickTypePopUpViewController
//        guard popViewController != nil else {return}
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
//            self.closeChildViewController()
//        })
//    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
        
        self.tabBarController?.tabBar.showTabBar()
        
        
        //При переходе через таб бар обновления не происходят
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Themer.shared.register(target: self, action: CategoriesViewController.theme(_:))
        
        segmentedControl.changeValuesForCashApp(segmentOne:NSLocalizedString("segmented_control_0", comment: ""), segmentTwo: NSLocalizedString("segmented_control_1", comment: ""))
        setupNavigationController(Navigation: navigationController!)
        self.navigationItem.title = NSLocalizedString("categories_navigation_title", comment: "") // Обязательно писать именно так, (вместо title) иначе таббар присвоит это значение
        blurView.bounds = self.view.frame
        setupCollectionView()
        
        
    }

    //MARK: Add/Delete Child View Controller
  
    
    func closeChildViewController() {
        self.view.reservedAnimateView(animatedView: popViewController.view, viewController: popViewController)
        popViewController = nil // Это нужно для того, чтобы снова его открыть. Потому что в открытии стоит условие
        self.view.reservedAnimateView(animatedView: blurView, viewController: nil)
        
    }
    
}

//MARK: Collectiom view delegate dataSource
extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
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
             
            let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(4.5/5), heightDimension: .fractionalHeight(4.5/5)))
            if self.view.bounds.width > 400 {
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
            }
            
            let subGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(2/5)), subitem: trailingItem, count: 3)
           // subGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(25)
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
                let object =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                addChildViewController(PayObject: object)
            }else{
                goToAddVC(object: nil, isEditing: false)
            }
        case false:
            if indexPath.row != incomeObjects.count {
                let object =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                addChildViewController(PayObject: object)
            }else{
                goToAddVC(object: nil, isEditing: false)
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let press = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: press) {
            
           //отмена нажатия если нажата кнопка "добавить новую категорию"
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


extension CategoriesViewController: ReloadParentTableView {
    func reloadData() {
        collectionView.reloadData()
    }
}

extension CategoriesViewController: ClosePopUpTableViewProtocol {
    
    enum isEditing{
        case edit
        case create
    }
    
    func goToAddVC(object: MonetaryCategory?, isEditing: Bool){
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addCategoryVC") as! AddOperationViewController
        addVC.tableReloadDelegate = self
        addVC.isEditingCategory = isEditing
        if object != nil {
            addVC.newCategoryObject = object!
        }else{
        addVC.newCategoryObject.stringEntityType = changeValue ? .expence : .income
        }
       
        present(addVC, animated: true, completion: nil)
    }
    
    func closeTableView(object: Any) {
        guard let object = object as? [String: IndexPath] else {return}
        let index = object.values.first
        let categoryObject = changeValue ? expenceObjects[index!.row] : incomeObjects[index!.row]
        switch object.keys.first {
        case "Edit":
            print(categoryObject)
            //Нужно делать запуск контроллера в фоновом потоке так как он открывается не дождавшись выгрузки поп менюшки
            DispatchQueue.main.async {
                self.goToAddVC(object: categoryObject, isEditing: true)
            }
        case "Delete":
            try! realm.write({
                realm.delete(categoryObject)
            })
            collectionView.deleteItems(at: [index!])
            collectionView.reloadData()
        default:
            break
        }
        
        
    }
    
}

extension CategoriesViewController: UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension CategoriesViewController {
    private func theme(_ theme: MyTheme ) {
        view.backgroundColor = theme.settings.backgroundColor
    }
}
