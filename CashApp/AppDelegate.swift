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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = true // Бар для доп кнопок
//        
        
        ThemeManager.applyTheme(theme: .white)
        
        let schemaVersion: UInt64 = 3 // Realm schemaVersion
    
        let config = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
            // totalBytes refers to the size of the file on disk in bytes (data + free space)
            // usedBytes refers to the number of bytes used by data in the file

            // Compact if the file is over 100MB in size and less than 50% 'used'
            let oneHundredMB = 100 * 1024 * 1024
            return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        do {
            // Realm is compacted on the first open if the configuration block conditions were met.
            let realm = try Realm(configuration: config)
        } catch {
            // handle error compacting or opening Realm
        }
        
//        let config = Realm.Configuration(
//            // Set the new schema version. This must be greater than the previously used
//            // version (if you've never set a schema version before, the version is 0).
//            schemaVersion: schemaVersion,
//
//            // Set the block which will be called automatically when opening a Realm with
//            // a schema version lower than the one set above
//            migrationBlock: { migration, oldSchemaVersion in
//                // We haven’t migrated anything yet, so oldSchemaVersion == 0
//                if (oldSchemaVersion < schemaVersion) {
//                    // Nothing to do!
//                    // Realm will automatically detect new properties and removed properties
//                    // And will update the schema on disk automatically
//                }
//        })
        
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

