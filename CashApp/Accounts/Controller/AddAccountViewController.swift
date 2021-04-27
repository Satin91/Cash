//
//  AddAccountViewController.swift
//  CashApp
//
//  Created by Артур on 21.01.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
let accountsImages = ["account1","account2","account3","account4"]
protocol scrollToNewAccount {
    func scrollToNewAccount(account: MonetaryAccount)
}
class AddAccountViewController: UIViewController {

    var indexForImage: IndexPath = [0,0]
    //Border neo bouds for textFields

    var scrollToNewAccountDelegate: scrollToNewAccount!
    @IBOutlet var collectionView: UICollectionView! // Делегат и источник назначены в сториборде
    
    //Actions buttons
    @IBAction func createAccountAction(_ sender: Any) {
        saveElement()
        scrollToNewAccountDelegate.scrollToNewAccount(account: newAccountObject)
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
    }
 
    var newAccountObject = MonetaryAccount()
    //TextLabels
    @IBOutlet var headingTextLabel : UILabel!
    //TextFields
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var balanceTextField : NumberTextField!
    //Outlets
    @IBOutlet var selectDateButtonOutlet: UIButton!
    //Actions
    @IBAction func selectDateButton(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViwSettings()
        setupNavigationController(Navigation: navigationController!)
        setColorTheme()
        visualSettings()
        setTextForViewElements()
        
    }
    func saveElement(){
        newAccountObject.imageForAccount = accountsImages[indexForImage.row]
        if !nameTextField.text!.isEmpty{
            newAccountObject.name = nameTextField.text!
        }
        if !balanceTextField.text!.isEmpty {
            newAccountObject.balance = Double(balanceTextField.text!)!
        }
        DBManager.addAccountObject(object: [newAccountObject])
        
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
    }
    func setTextForViewElements() {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        balanceTextField.attributedPlaceholder = NSAttributedString(string: "Balance", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        selectDateButtonOutlet.setTitle("Select Date", for: .normal)
        navigationItem.rightBarButtonItem?.title = "Create"
        navigationItem.leftBarButtonItem?.title = "Cancel"
        //Labels
        headingTextLabel.numberOfLines = 0
        headingTextLabel.text = "Add \nnew\naccount"
    }
    
    
    func collectionViwSettings() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true // Позволяет считать ячейки для того чтобы центрировать при прокрутке, хотя тут вообще он сам по себе центрирует без лишних методов)) очень удобно!
    }
    
    func languageSettings() {
        
    }
    
    func visualSettings(){
        nameTextField.borderStyle = .none
        balanceTextField.borderStyle = .none
        
        selectDateButtonOutlet.setTitleColor(whiteThemeMainText, for: .normal)
        selectDateButtonOutlet.titleLabel?.setLabelSmallShadow(label: selectDateButtonOutlet.titleLabel!)
        for i in [nameTextField,balanceTextField]{
            i!.textColor = .systemGray
        }
    }
  
    func setColorTheme() {
        self.view.backgroundColor = whiteThemeBackground
        self.collectionView.backgroundColor = .none
        headingTextLabel.textColor = whiteThemeMainText

        
    }
    
    
    
}
extension AddAccountViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    //                  UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: view.bounds.width , height: collectionView.bounds.height)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    //CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountsImages.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect() // создали квадрат
        
        visibleRect.origin = collectionView.contentOffset // инициализировали квадрат
        visibleRect.size = collectionView.bounds.size // задали ему размеры как у колекции
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY) // установили точку в центре квадрата
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return } //проверка на присутствие ячейки в этой точке
        indexForImage = indexPath
        print(indexPath) // отладочная печать для индекса
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAccountCell", for: indexPath) as! AddCollectionViewCell
        let images = accountsImages[indexPath.item]
        //let image = imageToData(imageName: images) // Перевод в Data нужен лишь для того чтобы потом можно было с легкостью сохранить изображение в базу данных, открыть в ячейке можно и не png файл
        cell.accountImageView.image = UIImage(named: images)
        cell.accountImageView.layer.cornerRadius = 20
        cell.accountImageView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
}


