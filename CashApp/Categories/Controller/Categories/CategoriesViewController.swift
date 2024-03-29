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
    
    let colors = AppColors()
    let subscriptionManager = SubscriptionManager()
    var navBarButtons: NavigationBarButtons!
    var changeValue = true
    var pressedIndexPath: IndexPath?
    ///             Outlets:
    @IBOutlet var segmentedControl: HBSegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    var openBarChartController: OpenNextController!
    ///            Actions:
    @IBAction func actionSegmentedControl(_ sender: HBSegmentedControl) {
        sender.changeSegmentWithAnimation(tableView: nil, collectionView: collectionView, ChangeValue: &changeValue)
    }

    
    
    ///             POPUP VIEW
    @IBOutlet var blurView: UIVisualEffectView! // не используется влом удалять пока
    ///             ACTIONS
 
    @objc var openBarChartButton: CancelButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
        self.tabBarController?.tabBar.showTabBar()
        
        
        //При переходе через таб бар обновления не происходят
    }
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.loadColors()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        Themer.shared.register(target: self, action: CategoriesViewController.theme(_:))
        openBarChartController = OpenNextController(storyBoardID: "BarChart", fromViewController: self, toViewControllerID: "BarChartID", toViewController: BarChartViewController())
        
        segmentedControl.changeValuesForCashApp(segmentOne:NSLocalizedString("segmented_control_0", comment: ""), segmentTwo: NSLocalizedString("segmented_control_1", comment: ""))
        //setupNavigationController(navigationController!)
        self.navigationItem.title = NSLocalizedString("categories_navigation_title", comment: "") // Обязательно писать именно так, (вместо title) иначе таббар присвоит это значение
        blurView.bounds = self.view.frame
        setupCollectionView()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        self.navBarButtons = NavigationBarButtons(navigationItem: navigationItem, leftButton: .none, rightButton: .chart)
        self.navBarButtons.setRightButtonAction { [weak self] in
            guard let self = self else { return }
            self.openBarChartController.makeTheTransition()
        }
    }
    //MARK: Add/Delete Child View Controller
  
//    func closeChildViewController() {
//        self.view.reservedAnimateView(animatedView: popViewController.view, viewController: popViewController)
//        popViewController = nil // Это нужно для того, чтобы снова его открыть. Потому что в открытии стоит условие
//        self.view.reservedAnimateView(animatedView: blurView, viewController: nil)
//    }
    enum isEditing{
        case edit
        case create
    }
    
    func goToAddVC(object: MonetaryCategory?, isEditing: Bool){
        let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addCategoryVC") as! AddOperationViewController
        
        let vc = UINavigationController(rootViewController: addVC)
        vc.modalPresentationStyle = .pageSheet
        
        addVC.tableReloadDelegate = self
        addVC.isEditingCategory = isEditing
        if object != nil {
            addVC.newCategoryObject = object!
        }else{
        addVC.newCategoryObject.stringEntityType = changeValue ? .expence : .income
        }
       
        present(vc, animated: true, completion: nil)
    }

}




extension CategoriesViewController: ReloadParentTableView {
    func reloadData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) , execute: {
            print("done")
            
            self.collectionView.performBatchUpdates {
                switch self.changeValue {
                case true:
                    self.collectionView.insertItems(at: [IndexPath(row: expenceObjects.count - 1, section: 0)])
                case false:
                    self.collectionView.insertItems(at: [IndexPath(row: incomeObjects.count - 1, section: 0)])
                }   
            }
        })
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
