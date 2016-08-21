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
    
    var nextTopFlowLayout : UICollectionViewLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Need to manually set frames of collectionViews
        topCollectionView.translatesAutoresizingMaskIntoConstraints = true
        topCollectionView.frame = self.view.frame.rect(heightMultipliedByFactor: 0.5)
        
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = true
        bottomCollectionView.frame = self.view.frame.rect(heightMultipliedByFactor: 0.5, y:topCollectionView.frame.size.height)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if nextTopFlowLayout == nil {
            nextTopFlowLayout = singleFlowLayout(topCollectionView)
            
            if let topDelegate = topCollectionView.delegate as? SimpleDelegate {
                topDelegate.didSelectBlock = { (layout, indexPath) in

                    self.topCollectionView.collectionViewLayout.invalidateLayout()
                    
                    let previousFlowLayout = self.topCollectionView.collectionViewLayout
                    
                    self.topCollectionView.setCollectionViewLayout(self.nextTopFlowLayout!, animated: true)
                    self.nextTopFlowLayout = previousFlowLayout
                }
            }
        }
    }
    
    func singleFlowLayout(collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let padding : CGFloat = 10.0
        
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth = collectionView.frame.size.width - (2 * padding)
        let itemHeight = collectionView.frame.size.height - (2 * padding)
        
        layout.itemSize = CGSizeMake(itemWidth, itemHeight)
        layout.minimumInteritemSpacing = padding * 2
        layout.minimumLineSpacing = padding * 2
        
        return layout
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let isPortrait = size.height > size.width
        let origin = self.view.frame.origin
        let newFrame = CGRectMake(origin.x, origin.y, size.width, size.height)
        
        coordinator.animateAlongsideTransition({ context in
            
            self.topCollectionView.frame = isPortrait
                ? newFrame.rect(heightMultipliedByFactor: 0.5)
                : newFrame.rect(widthMultipliedByFactor: 0.5)
            
            self.bottomCollectionView.frame = isPortrait
                ? self.view.frame.rect(heightMultipliedByFactor: 0.5, y:self.topCollectionView.frame.size.height)
                : self.view.frame.rect(widthMultipliedByFactor: 0.5, x:self.topCollectionView.frame.size.width)
            
        }, completion: nil)
    }
}

