//
//  SimpleDataSource.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 6/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit
import Foundation

class SimpleDataSource: NSObject, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellReuseIdentifier", forIndexPath: indexPath)
        
        if let cell = cell as? Cell {
            
            cell.title.text = "\(indexPath.section).\(indexPath.item)"
            cell.title.sizeToFit()
            
            if (collectionView.tag == 0) {
                cell.contentView.backgroundColor = UIColor.random(red: 1.00) // Make random self color, but red-ish
            } else {
                cell.contentView.backgroundColor = UIColor.random(green: 1.00) // Make random self color, but green-ish
            }
            
            let totalItems = collectionView.numberOfItemsInSection(indexPath.section)
            // Make cells fading in opacity down to 0.25 for last item
            // First quarter of items will be > 1.0 which is interpreted as 1.00
            let alpha = 1.25 - (CGFloat(indexPath.item) / CGFloat(totalItems))
            cell.contentView.backgroundColor = cell.contentView.backgroundColor?.colorWithAlphaComponent(alpha)
        }
        
        return cell
    }
}