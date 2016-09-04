//
//  UICollectionViewFlowLayout+SingleItemFlow.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 22/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout {
    
    func configureForSingleItemFlow(inCollectionView collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let padding : CGFloat = 10.0
        
        let itemWidth = floor(collectionView.frame.size.width - (2 * padding))
        let itemHeight = floor(collectionView.frame.size.height - (2 * padding))
        
        self.itemSize = CGSizeMake(itemWidth, itemHeight)
        self.minimumInteritemSpacing = padding * 2
        self.minimumLineSpacing = padding * 2
        self.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            self.scrollDirection = flowLayout.scrollDirection
        }
        
        return self
    }
}