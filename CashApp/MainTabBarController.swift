//
//  MainTabBarController.swift
//  CashApp
//
//  Created by Артур on 2.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    @IBOutlet var mainBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainBar.isTranslucent = true
        mainBar.barStyle = .default
        mainBar.barTintColor = .systemBackground
        mainBar.unselectedItemTintColor = .systemGray3
        mainBar.tintColor = .systemRed
        
        setTabBarItems()
        tabBarItem.title = ""
        
        
    }
    
    func setTabBarItems(){
        
        let image = UIImage(systemName: "house.fill")
        image?.imageRendererFormat.scale = 1.5
        
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        //myTabBarItem1.image = UIImage(named: "card")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //myTabBarItem1.selectedImage = UIImage(named: "card")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        myTabBarItem1.title = "Home"
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
//        myTabBarItem2.image = UIImage(named: "savings")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
       // myTabBarItem2.selectedImage = UIImage(named: "savings")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        myTabBarItem2.title = "Operations"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.title = "Scheduler"
        
        
//
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
