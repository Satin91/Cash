//
//  AddAccountViewController.swift
//  CashApp
//
//  Created by Артур on 21.01.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {
    
 
    var textForUpperLabel = ""
    var textForMiddleLabel = ""
    var textForBottomLabel = ""
    
    @IBOutlet var collectionView: UICollectionView! // Делегат и источник назначены в сториборде
    
    var newAccount = MonetaryAccount()
    //TextLabels
    @IBOutlet var upperTextLabel : UILabel!
    @IBOutlet var middleTextLabel : UILabel!
    @IBOutlet var bottomTextLabel : UILabel!
    //TextFields
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var targetTextField : UITextField!
    @IBOutlet var balanceTextField : UITextField!
    //Outlets
    @IBOutlet var selectDateButtonOutlet: UIButton!
    //Actions
    @IBAction func selectDateButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViwSettings()
        setupNavigationController(Navigation: navigationController!)
        setColorTheme()
        textForLabels()
        visualSettings()

        
        
        
    }
    func collectionViwSettings() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true // Позволяет считать ячейки для того чтобы центрировать при прокрутке, хотя тут вообще он сам по себе центрирует без лишних методов)) очень удобно!
    }
    
    func textForLabels(){
        upperTextLabel.text = textForUpperLabel
        middleTextLabel.text = textForMiddleLabel
        bottomTextLabel.text = textForBottomLabel
        
    }
    
    func visualSettings(){
        nameTextField.borderStyle = .none
        targetTextField.borderStyle = .none
        balanceTextField.borderStyle = .none
    }
    
    func setColorTheme() {
        self.view.backgroundColor = whiteThemeBackground
        self.collectionView.backgroundColor = .none
        upperTextLabel.textColor = whiteThemeMainText
        middleTextLabel.textColor = whiteThemeRed
        bottomTextLabel.textColor = whiteThemeMainText
        
        
        setCustomShadow(label: upperTextLabel, color: whiteThemeShadowText.cgColor, radius: 3, opacity: 0.6, size: CGSize(width: 2, height: 2))
        setCustomShadow(label: middleTextLabel, color: whiteThemeShadowText.cgColor, radius: 3, opacity: 0.6, size: CGSize(width: 2, height: 2))
        setCustomShadow(label: bottomTextLabel, color: whiteThemeShadowText.cgColor, radius: 3, opacity: 0.6, size: CGSize(width: 2, height: 2))
        
    }
    
    
    
}
extension AddAccountViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //                  UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: view.bounds.width - 104, height: collectionView.bounds.height)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 104
    }
    //CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAccountCell", for: indexPath) as! AddCollectionViewCell
        cell.accountImageView.image = UIImage(named: "cash")
        
        print(indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }

}


