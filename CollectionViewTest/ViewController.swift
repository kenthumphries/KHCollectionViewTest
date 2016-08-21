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

}

