//
//  AppDelegate.swift
//  CashApp
//
//  Created by Артур on 7/26/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import UserNotifications
import Themer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let purchaseManager = Store()
    let notifications = Notifications()
    let navBar = setupNavigationBar()
    let subscriptionManager = SubscriptionManager()
    let currencyModelCOntroller = CurrencyModelController()
    let networking = CurrencyNetworking()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NetworkMonitor.shared.startMonitoring() // Проверка на интернет соединение
        //Purchases.configure(with/Users/artur/Xcode/CashApp/CashUP/CashApp/AppDelegate.swiftAPIKey: "HEYSketqpvpcIaiqZPyywaOdrTKmtVzE") // API для получение данных о подписке
        //Purchases.logLevel = .debug // Режим дебагинга (работает без включения "чистой консоли")
        
        self.purchaseManager.fetchProducts() // Проверка на активность подписки
      //  self.subscriptionManager.checkActiveEntitlement() // Проверка на активность подписки
        self.networking.loadCurrencies() // Загрузка валют (есть 2 варианта: из локального JSON и из API) (перед вызовом метода требуется проверка на интернет соединение)
        getCurrenciesByPriorities() // Удаление валют которые выше ограничений в случае истекшей подписки
        checkBlockedSchedulers() // Блокировка или разблокировка планов
        checkBlockedAccounts() // Блокировка или разблокировка счетов
        IQKeyboardManager.shared.enable = true
        IsLightTheme.checkTheme() // устанавливает действующую тему оформления
        navBar.setColors()
        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        NetworkMonitor.shared.stopMonitoring()
        return true
    }
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let schemaVersion: UInt64 = 4
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: schemaVersion,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                print(schemaVersion)
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < schemaVersion) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
   
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

#if DEBUG
let certificate = "StoreKitTestCertificate"
#else
let certificate = "AppleIncRootCertificate"
#endif
