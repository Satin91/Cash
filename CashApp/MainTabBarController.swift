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
        mainBar.tintColor = .systemRed
        mainBar.backgroundColor = .blue
        setTabBarItems()
        tabBarItem.title = ""
        mainBar.barTintColor = .blue
        
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

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}


// MyTabController.swift

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = ThemeManager.currentTheme().backgroundColor
        self.tabBar.tintColor = ThemeManager.currentTheme().titleTextColor
        self.tabBar.unselectedItemTintColor = ThemeManager.currentTheme().subtitleTextColor
        
        setTabBarItems()
    }
    func setTabBarItems(){
    
        let imagesss = UIImageView(image: UIImage(named: "home") )
        imagesss.contentMode = .scaleAspectFit
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = imagesss.image
        myTabBarItem1.title = " "
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "categories")
        
        myTabBarItem2.title = " "
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        //myTabBarItem3.title = "Scheduler"
        myTabBarItem3.title = " "
        myTabBarItem3.image = UIImage(named: "scheduler")
        myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
}

extension MyTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}

class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.52

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }

        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart

        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            
            UIView.animate(withDuration: self.transitionDuration,delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut,  animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }

    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
