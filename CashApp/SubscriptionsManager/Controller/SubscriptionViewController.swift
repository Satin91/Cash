//
//  SubscriptionViewController.swift
//  CashApp
//
//  Created by Артур on 6.11.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import StoreKit
import Themer

class SubscriptionViewController: UIViewController {
    @IBOutlet var HeaderLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var monthButtonOutlet: ContrastButton!
    @IBOutlet weak var annualButtonOutlet: UIButton!
    @IBOutlet weak var restoreButtonOutlet: UIButton!
    let store = Store()
    var alert: MiniAlertView!
    let colors = AppColors()
    let subscriptioDescription = SubscriptionCellModelController().subscriptionModel
    var navBarButtons: NavigationBarButtons!
    @IBAction func monthlySubscription(_ sender: ContrastButton) {
        guard store.products.first != nil else { return }
        self.store.purchase(product: store.products[0])
    }
    @IBAction func AnnualSubscription(_ sender: UIButton) {
        guard store.products.first != nil else { return }
        self.store.purchase(product: store.products[1])
    }
    
    @IBOutlet weak var privacyPolicyButtonOutlet: UIButton!
    @IBOutlet weak var termOfServiceButtonOutlet: UIButton!
    @IBAction func termOfUseButtonAction(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
             UIApplication.shared.open(url, options: [:])
         }
    }
    @IBAction func privacyPolicyButtonAction(_ sender: UIButton) {
        if let url = URL(string: NSLocalizedString("privacy_policy_URL", comment: "")) {
             UIApplication.shared.open(url, options: [:])
         }
        
    }
    @IBAction func restoreAction(_ sender: UIButton) {
        store.fetchProducts()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alert = MiniAlertView.loadFromNib()
        self.alert.controller = self
        self.colors.loadColors()
        setupCollectionView()
        store.fetchProducts()
        setupView()
        createNavBarButtons()
        // Уведомления для того чтобы установить тайтл с прайсом кнопкам
        NotificationCenter.default.addObserver(self, selector: #selector(setButtonsTitle(_:)), name: NSNotification.Name("ReceiveSubscriptionsProducts"), object: nil)
    }
    @objc func setButtonsTitle(_ notification: Notification) {
        guard let object = notification.object as? [String: Int] else { return }
        // Проверка пришло ли уведомление об объектах подписки
        if object.first?.key == "Success" {
            setPriceToButtons(isReceiveObjects: .success)
        } else {
            setPriceToButtons(isReceiveObjects: .error)
        }
    }
    
    
    func createNavBarButtons() {
        self.navBarButtons = NavigationBarButtons(navigationItem: navigationItem, leftButton: .none, rightButton: .cancel)
        self.navBarButtons.setRightButtonAction {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    enum IsReceiveSabscriptionProducts {
        case success
        case error
    }
    
    func setButtonProperties(button: UIButton) {
        button.backgroundColor = colors.contrastColor1
        button.layer.setSmallShadow(color: colors.shadowColor)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 8
        button.setTitleColor(colors.whiteColor, for: .normal)
    }
    func setupView() {
        self.view.backgroundColor = colors.secondaryBackgroundColor
        self.HeaderLabel.textColor = colors.titleTextColor
        self.HeaderLabel.text = "Monetaria PRO"
        self.collectionView.backgroundColor = .clear
        pageControl.currentPageIndicatorTintColor = colors.titleTextColor
        pageControl.pageIndicatorTintColor = colors.borderColor
        setButtonProperties(button: monthButtonOutlet)
        setButtonProperties(button: annualButtonOutlet)
        restoreButtonOutlet.backgroundColor = Themer.shared.theme == .dark ? colors.backgroundcolor : colors.secondaryBackgroundColor
        restoreButtonOutlet.setTitleColor(colors.contrastColor1, for: .normal)
        restoreButtonOutlet.layer.cornerCurve = .continuous
        restoreButtonOutlet.layer.cornerRadius = 8
        restoreButtonOutlet.layer.setSmallShadow(color: colors.shadowColor)
        restoreButtonOutlet.setTitleColor(colors.contrastColor1, for: .normal)
        termOfServiceButtonOutlet.setTitle("Term of service", for: .normal)
        privacyPolicyButtonOutlet.setTitle("Privacy Policy", for: .normal)
        restoreButtonOutlet.setTitle(NSLocalizedString("restore_button", comment: ""), for: .normal)
        termOfServiceButtonOutlet.setTitleColor(colors.titleTextColor, for: .normal)
        privacyPolicyButtonOutlet.setTitleColor(colors.titleTextColor, for: .normal)
      //  privacyPolicyButtonOutlet.titleLabel?.textColor = colors.contrastColor1
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

       
    func setPriceToButtons(isReceiveObjects: IsReceiveSabscriptionProducts) {
        let trial = SubscribtionStatus.trialWasActive == false ? NSLocalizedString("subscribe_free_label", comment: "") : ""
        let afterMonthLabel = NSLocalizedString("subscribe_month_sum_label", comment: "")
        let afterYearLabel  = NSLocalizedString("subscribe_year_sum_label", comment: "")
        if isReceiveObjects == .error {
            DispatchQueue.main.async {
                print("Значения установились")
                self.monthButtonOutlet.setTitle( "$1.55" + afterMonthLabel + " \(trial)", for: .normal)
                self.annualButtonOutlet.setTitle("$11.55" + afterYearLabel + " \(trial)", for: .normal)
            }
        } else {
        DispatchQueue.main.async {
            print("Значения установились")
            let price = [self.store.products[0].displayPrice, self.store.products[1].displayPrice]
            self.monthButtonOutlet.setTitle( price[0] + afterMonthLabel + " \(trial)", for: .normal)
            self.annualButtonOutlet.setTitle(price[1] + afterYearLabel + " \(trial)", for: .normal)
        }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


//extension SubscriptionViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//
//        if let product = response.products.first {
//            print("Product is available")
//            self.purchase(product: product)
//        } else {
//            print("Product is not available")
//        }
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .purchasing:
//                print("Customer in the process")
//            case .purchased:
//                SKPaymentQueue.default().finishTransaction(transaction)
//                print("Purchased")
//            case .failed:
//                SKPaymentQueue.default().finishTransaction(transaction)
//                print("Failed")
//            case .restored:
//                print("Restored")
//            case .deferred:
//                print("Deferred")
//            @unknown default:
//                break
//            }
//        }
//    }
//}
