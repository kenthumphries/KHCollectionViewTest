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
    
    var topPreselectedItems : [NSIndexPath]?
    var bottomPreselectedItems : [NSIndexPath]?
    
    var topCollectionViewDidSelectBlock: DidSelectBlock {
        return { (layout, indexPath) in

            self.performSegueWithIdentifier(self.segueIdentifier, sender: self)
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
        
        let frames = self.collectionViewFrames()
        self.configureCollectionView(self.topCollectionView,
                                     frame: frames.top,
                                     didSelectBlock: self.topCollectionViewDidSelectBlock,
                                     preselectedItems: self.topPreselectedItems)

        self.configureCollectionView(self.bottomCollectionView,
                                     frame: frames.bottom,
                                     didSelectBlock: self.bottomCollectionViewDidSelectBlock,
                                     preselectedItems: self.bottomPreselectedItems)
    }
    
    func configureCollectionView(collectionView:UICollectionView, frame:CGRect, didSelectBlock:DidSelectBlock, preselectedItems:[NSIndexPath]?) {
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.frame = frame
        
        if let delegate = collectionView.delegate as? SimpleDelegate {
            delegate.didSelectBlock = didSelectBlock
        }
        
        // Ensure preselectedItems are selected
        if let preselectedItems = preselectedItems {
            for indexPath in preselectedItems {
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let destinationVC = segue.destinationViewController as? ViewController where segue.identifier == self.segueIdentifier {
            destinationVC.topPreselectedItems = self.topCollectionView.indexPathsForSelectedItems()
            destinationVC.bottomPreselectedItems = self.bottomCollectionView.indexPathsForSelectedItems()
        }
    }
    
    @IBAction func unwindToViewController(segue:UIStoryboardSegue) {
        
    }
}