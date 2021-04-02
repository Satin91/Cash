//
//  TotalBalanceSchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 9/29/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar



class AccountsViewController: UIViewController, dismissVC{
 
    
    @IBOutlet var containerView: UIView!
    
    @IBAction func upperAactionButton(_ sender: Any) {
        accountsCollectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var topConstreintOfCollectionView: NSLayoutConstraint!
    @IBOutlet var accountsCollectionView: UICollectionView!
    var upperButtonName = "Top up"
  
    let shapLayer = CAShapeLayer()
    var entityModel: MonetaryAccount?
    let image = UIImageView()
    
    //Buttons outlets
    @IBOutlet var upperButton: UIButton!

    ///Unused
    var center = CGPoint()
    
    ///Buttons images
    @IBAction func backButton(_ sender: Any) {
        
    }
    @IBOutlet var upperButtonImage: UIImageView!
    @IBOutlet var middleButtonImage: UIImageView!
    @IBOutlet var bottomButtonImage: UIImageView!
    @IBAction func addButton(_ sender: Any) {
        //addVC
  
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pickTypeVC = storyboard.instantiateViewController(withIdentifier: "pickTypeVC") as! PickTypePopUpViewController
        let navVC = UINavigationController(rootViewController: pickTypeVC)
        pickTypeVC.buttonsNames = ["Card","Cash","Savings"]
        pickTypeVC.goingTo = "addAccountVC"
        pickTypeVC.delegate = self
        navVC.modalPresentationStyle = .pageSheet
        // Передача данных описана в классе PickTypePopUpViewController
        present(navVC, animated: true, completion: nil)
    }
    
 
    
    func sendNotification(objectAt: IndexPath?) {
        guard let indexPath = objectAt else {return}
        
        visibleObject = EnumeratedAccounts(array: accountsObjects)[indexPath.row]
        
        guard let Object = visibleObject else{return}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MonetaryAccount"), object: Object)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard accountsObjects.count != 0 else {return}
        visibleIndexPath = accountsCollectionView.indexPathsForVisibleItems.first
        sendNotification(objectAt: visibleIndexPath)
        print("Accounts view did appear")
    }
    

 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        accountsCollectionView.delegate = self
        accountsCollectionView.dataSource = self
        accountsCollectionView.backgroundColor = .clear
        accountsCollectionView.isPagingEnabled = true
        let nib = UINib(nibName: "AccountCollectionViewCell", bundle: nil)
        accountsCollectionView.register(nib, forCellWithReuseIdentifier: AccountCollectionViewCell().identifier)
        blurView.frame = self.view.bounds
        //headerLabel.text = entityModel?.name
        //sumLabel.text = String(entityModel!.balance.currencyFR)
        setupNavigationController(Navigation: navigationController!)
        //accountImage.image = UIImage(data: entityModel!.imageForAccount!)
        navigationItem.title = entityModel?.initType()
        self.view.insertSubview(self.blurView, at: 5)
        blurView.layer.opacity = 0
        
        self.view.backgroundColor = whiteThemeBackground
        
        
    }
    
    
    func layout() {
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
    
    
   
    

   
//    func checkType(){
//        switch entityModel?.stringAccountType {
//        case .box:
//            schedule.isHidden = true
//            //BoxView
//            boxView.isHidden = false
//        case .cash :
//            schedule.isHidden = true
//            boxView.isHidden = true
//        case .card :
//            boxView.isHidden = true
//            schedule.isHidden = false
//            //CalendarView
//
//        default:
//            break
//        }
//    }
 
    var accountsLabelsNames = ["Add","card","cash","savings"]
    var bottomLabelText = ["to accounts","to schedule","category"]
    func dismissVC(goingTo: String,restorationIdentifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addAccountVC = storyboard.instantiateViewController(identifier: "addAccountVC") as! AddAccountViewController
        if goingTo == "addAccountVC" {
            switch restorationIdentifier {
            case "upper":
                addAccountVC.newAccount.stringAccountType = .card
                addAccountVC.textForMiddleLabel = accountsLabelsNames[1]
            case "middle":
                addAccountVC.newAccount.stringAccountType = .cash
                addAccountVC.textForMiddleLabel = accountsLabelsNames[2]
            case "bottom":
                addAccountVC.newAccount.stringAccountType = .box
                addAccountVC.textForMiddleLabel = accountsLabelsNames[3]
            default:
                return
            }
            addAccountVC.textForUpperLabel = accountsLabelsNames[0]  // Здесь 0 для удобства т.к. модель начинается с единицы
            addAccountVC.textForBottomLabel = bottomLabelText[0]
        }
        let navVC = UINavigationController(rootViewController: addAccountVC)
        navVC.modalPresentationStyle = .pageSheet
        
        present(navVC, animated: true)
    }
    var visibleObject:     MonetaryAccount?
    var visibleIndexPath:  IndexPath!
    var selectedIndexPath: IndexPath!
    var selectedObject:    MonetaryAccount?
    var toggle = false //Нажата ли кнопка
    
    }



extension AccountsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return (selectedObject != nil) ? accountsImages.count :  EnumeratedAccounts(array: accountsObjects).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell().identifier , for: indexPath) as! AccountCollectionViewCell
        cell.delegate = self
        if selectedObject != nil {
            let object = selectedObject
            let images = UIImage(named: accountsImages[indexPath.row])
            cell.setForSelect(image: images!, name: object!.name, balance: String(object!.balance), target: String(object!.targetSum), account: object!)
            //Установил наблюдатель иммено здесь потому что нужно чтобы он действовал на все выводимые ячейки, а не на единственную как было бы, если б установил это в протоколе нажатия на кнопку
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TextFieldIsEnabled"), object: nil, userInfo: ["CASE":true])
            return cell
        }else{
        let object = EnumeratedAccounts(array: accountsObjects)[indexPath.row]
            cell.setAccount(account: object)
            //Установил наблюдатель иммено здесь потому что нужно чтобы он действовал на все выводимые ячейки, а не на единственную как было бы, если б установил это в протоколе нажатия на кнопку
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TextFieldIsEnabled"), object: nil, userInfo: ["CASE":false])
            return cell
        }
        
    }
        
}
//MARK: Collection protocol
extension AccountsViewController: collectionCellProtocol {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //  accountsCollectionView.reloadData()
        accountsCollectionView.reloadData()
        let visibleRect = CGRect(origin: accountsCollectionView.contentOffset, size: accountsCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath2 = accountsCollectionView.indexPathForItem(at: visiblePoint)
       // accountsCollectionView.reloadData()
        guard visibleIndexPath2 != nil else {
            return
        }
        if visibleIndexPath != visibleIndexPath2{ // Проверка на изменения ячейки
            visibleIndexPath = visibleIndexPath2
            sendNotification(objectAt: visibleIndexPath)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       //Классная функция. Применяется когда скрол останавливается
    }
   
    func cellTextFieldChanged(_ levelTableViewCell: AccountCollectionViewCell, didEndEditingWithText: String?, textFieldName: String!) {
        
        switch textFieldName {
        case "HeaderIsEditing":
            try! realm.write {
                selectedObject!.name = didEndEditingWithText!
            }
        case "BalanceIsEditing":
            try! realm.write {
                selectedObject!.balance = Double(didEndEditingWithText!)!
            }
        case "TargetIsEditing":
            try! realm.write {
                selectedObject!.targetSum = Double(didEndEditingWithText!)!
            }
        default:
            break
        }
    }
   
    
    func tapped(tapped: Bool) {
        
        switch toggle {
        case false: // Не в режиме редактирования
            // Инициализировали редактирование
            
            selectedIndexPath = visibleIndexPath
            // Вытащил объект по индексу
            selectedObject = EnumeratedAccounts(array: accountsObjects)[selectedIndexPath.row]
            // Сменил констрейнт и переместился к текущему изображению в редакторе
            changeConstraint()
            //accountsCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
            
            toggle.toggle()
         //   accountsCollectionView.reloadData()
        case true: // В режиме редактирования
            try! realm.write { // Позволяет менять текст объекта в реальном времени
                selectedObject!.imageForAccount = accountsImages[visibleIndexPath.row]
            }
            changeConstraint()
            // Вернул индекс в доВыбранное состояние птмчто возвращает текущий видимый и при новом нажатии на редактор возвращает нил
            visibleIndexPath = selectedIndexPath
            sendNotification(objectAt: visibleIndexPath)
            toggle.toggle()
        }
    }

    
    func changeConstraint() {
        if topConstreintOfCollectionView.constant == 14{
      
            UIView.animate(withDuration: 0.6) {
                self.blurView.layer.opacity = 1
                //self.view.layoutIfNeeded()
                self.topConstreintOfCollectionView.constant = 250
                self.view.layoutIfNeeded()
            }
            goToImageIndex()
            self.view.bringSubviewToFront(accountsCollectionView)// Для того чтобы графики не перекрывали карту
            self.accountsCollectionView.reloadData()
        }else{
            
            UIView.animate(withDuration: 0.6) {
                self.blurView.layer.opacity = 0
                //self.view.layoutIfNeeded()
                self.topConstreintOfCollectionView.constant = 14
                self.view.layoutIfNeeded()
                self.selectedObject = nil
            }
            
            self.accountsCollectionView.reloadData()
            backToIndex()
        }
    }
    
    func backToIndex() {
        accountsCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func goToImageIndex() {
        var imageIndex = IndexPath(row: 0, section: 0)
        for (index,value) in accountsImages.enumerated() {
            if selectedObject?.imageForAccount == value {
                imageIndex.row = index
            }
        }
        
        print(imageIndex)
        //Непонятно почему, но при анимировании скролится в пустоту
        accountsCollectionView.scrollToItem(at: imageIndex, at: .centeredHorizontally, animated: false)
        visibleIndexPath = imageIndex // В момент загрузки новых ячеек видимый индекс равен nil, по этому видемый индекс равен индексу текущего изображения
    }
    
}


//class CenterFlowLayout: UICollectionViewFlowLayout {
//
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//    if let cv = self.collectionView {
//       let cvBounds = cv.bounds
//       let halfWidth = cvBounds.size.width * 0.5
//       let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
//        if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) as [UICollectionViewLayoutAttributes]? {
//       var candidateAttributes: UICollectionViewLayoutAttributes?
//       for attributes in attributesForVisibleCells {
//     // == Skip comparison with non-cell items (headers and footers) == //
//        if attributes.representedElementCategory != UICollectionView.ElementCategory.cell {
//       continue
//     }
//     if let candAttrs = candidateAttributes {
//       let a = attributes.center.x - proposedContentOffsetCenterX
//       let b = candAttrs.center.x - proposedContentOffsetCenterX
//           if fabsf(Float(a)) < fabsf(Float(b)) {
//              candidateAttributes = attributes
//           }
//     } else { // == First time in the loop == //
//       candidateAttributes = attributes
//       continue
//     }
//   }
//   return CGPoint(x : candidateAttributes!.center.x - halfWidth, y : proposedContentOffset.y)
// }
//}
//// Fallback
//        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
//}
//}
