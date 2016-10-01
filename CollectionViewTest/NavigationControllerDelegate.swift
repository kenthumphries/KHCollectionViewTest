//
//  NavigationControllerDelegate.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 22/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerdelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let fromVC = fromVC as? ViewController {
            return ViewControllerCollectionViewsAnimator(animationCenters: fromVC.animationCenters)
        }

        return nil
    }
}
