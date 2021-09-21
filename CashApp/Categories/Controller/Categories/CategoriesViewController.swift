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
    

    private var popViewController: UIViewController! // Child View Controller
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
        //collectionView.layoutSubviews()
        self.tabBarController?.tabBar.showTabBar()
        
        
        //При переходе через таб бар обновления не происходят
    }
    @objc func openBarChart(_ sender: UIButton) {
        openBarChartController.makeTheTransition()
    }
    func createRightBarButton() {
        //openBarChartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25), title: .create, owner: self) as! CancelButton
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 240) )
       
        let image = UIImage(named: "linear.chart")
        let tintedColor = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedColor, for: .normal)
        
        button.tintColor = Themer.shared.theme == .dark ? .white : .black
        button.addTarget(self, action: #selector(CategoriesViewController.openBarChart(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        Themer.shared.register(target: self, action: CategoriesViewController.theme(_:))
       
        
//        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .paragraphStyle: paragraphStyle  ]
       
        createRightBarButton()
        openBarChartController = OpenNextController(storyBoardID: "BarChart", fromViewController: self, toViewControllerID: "BarChartID", toViewController: BarChartViewController())
        
        segmentedControl.changeValuesForCashApp(segmentOne:NSLocalizedString("segmented_control_0", comment: ""), segmentTwo: NSLocalizedString("segmented_control_1", comment: ""))
        //setupNavigationController(navigationController!)
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
    
    func closeTableView(object: Any) {
        guard let object = object as? [String: IndexPath] else {return}
        let index = object.values.first
        let categoryObject = changeValue ? expenceObjects[index!.row] : incomeObjects[index!.row]
        switch object.keys.first {
        case "Edit":
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
    

//    override func presentationTransitionWillBegin() {
//        chromeView.frame = self.containerView.bounds
//        chromeView.alpha = 0.0
//        containerView.insertSubview(chromeView, atIndex:0)
//        let coordinator = presentedViewController.transitionCoordinator()
//        if (coordinator != nil) {
//            coordinator!.animateAlongsideTransition({
//                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
//                    self.chromeView.alpha = 1.0
//            }, completion:nil)
//        } else {
//            chromeView.alpha = 1.0
//        }
//    }
}
extension CategoriesViewController {
    private func theme(_ theme: MyTheme ) {
        view.backgroundColor = theme.settings.backgroundColor
    }
}
