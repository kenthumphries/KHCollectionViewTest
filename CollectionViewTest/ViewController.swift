//
//  ViewController.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 5/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var topCollectionView: UICollectionView!
    @IBOutlet var bottomCollectionView: UICollectionView!
    
    var topCollectionViewFactor: CGFloat { return 0.5 }
    var bottomCollectionViewFactor: CGFloat { return 1.0 - self.topCollectionViewFactor }
    
    let segueIdentifier = "ShowOtherViewController"
    
    var topCollectionViewDidSelectBlock: DidSelectBlock {
        return { (layout, indexPath) in
            
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("OtherViewController") {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    var bottomCollectionViewDidSelectBlock: DidSelectBlock {
        return { (layout, indexPath) in
            
            self.performSegueWithIdentifier(self.segueIdentifier, sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View should reach behind the status bar
        self.edgesForExtendedLayout = .None
        
        // Need to manually set frames of collectionViews
        let frames = self.collectionViewFrames()
        topCollectionView.translatesAutoresizingMaskIntoConstraints = true
        topCollectionView.frame = frames.top
        
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = true
        bottomCollectionView.frame = frames.bottom
        
        if let topDelegate = topCollectionView.delegate as? SimpleDelegate {
            topDelegate.didSelectBlock = self.topCollectionViewDidSelectBlock
        }
        
        if let bottomDelegate = bottomCollectionView.delegate as? SimpleDelegate {
            bottomDelegate.didSelectBlock = self.bottomCollectionViewDidSelectBlock
        }
    }
        
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let frames = self.collectionViewFrames(size)
        
        coordinator.animateAlongsideTransition({ context in
            
            self.topCollectionView.frame = frames.top
            self.bottomCollectionView.frame = frames.bottom
            
        }, completion: nil)
    }
    
    func collectionViewFrames(size: CGSize? = nil) -> (top:CGRect, bottom:CGRect) {
        
        let origin = self.view.frame.origin
        let width = size?.width ?? self.view.frame.size.width
        let height = size?.height ?? self.view.frame.size.height
        
        let isPortrait = height > width
        
        let frame = CGRectMake(origin.x, origin.y, width, height)
        
        let top = isPortrait
            ? frame.rect(heightMultipliedByFactor: self.topCollectionViewFactor)
            : frame.rect(widthMultipliedByFactor: self.topCollectionViewFactor)
        
        let bottom = isPortrait
            ? frame.rect(heightMultipliedByFactor: self.bottomCollectionViewFactor, y:top.size.height)
            : frame.rect(widthMultipliedByFactor: self.bottomCollectionViewFactor, x:top.size.width)
        
        return (top, bottom)
    }
}