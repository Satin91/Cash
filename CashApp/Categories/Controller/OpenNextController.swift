//
//  OpenNextController.swift
//  CashApp
//
//  Created by Артур on 13.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class OpenNextController {
    
    var storyBoardID: String!
    var fromViewController: UIViewController!
    var toViewControllerID: String!
    var toViewController: UIViewController!
    
    
    
    init(storyBoardID: String, fromViewController: UIViewController,toViewControllerID: String, toViewController: UIViewController) {
        self.storyBoardID = storyBoardID
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.toViewControllerID = toViewControllerID
    }
    
    func makeTheTransition() {
        let storyboard = UIStoryboard(name: storyBoardID, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: toViewControllerID)
        viewController.modalPresentationStyle = .popover
        let vc = UINavigationController(rootViewController: viewController)
        vc.modalPresentationStyle = .pageSheet
        fromViewController.present(vc, animated: true, completion: nil)
    }
}
