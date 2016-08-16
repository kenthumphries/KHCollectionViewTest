//
//  UICollectionView+SortedIndexPaths.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 11/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func sortedIndexPathsForVisibleItems() -> [NSIndexPath] {
        return self.indexPathsForVisibleItems().sort({ (first, second) -> Bool in
            return first.section < second.section || (first.section == second.section && first.item <= second.item)
        })
    }
    
    func firstVisibleSelectedIndexPath() -> NSIndexPath? {

        let visibleIndexPaths = self.sortedIndexPathsForVisibleItems()
        
        if let selectedIndexPaths = self.indexPathsForSelectedItems(),
            visibleSelectedIndexPath = NSArray(array: visibleIndexPaths).firstObjectCommonWithArray(selectedIndexPaths) as? NSIndexPath {
            // One of the selected cels is visible
            return visibleSelectedIndexPath
        }
        return nil
    }
}

