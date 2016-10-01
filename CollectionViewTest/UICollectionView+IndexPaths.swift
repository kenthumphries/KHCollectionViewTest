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
    
    func matchSelectedItemsFromCollectionView(collectionView:UICollectionView) {
        
        var newIndexPaths = collectionView.indexPathsForSelectedItems()
        if newIndexPaths == nil {
            newIndexPaths = []
        }
        
        if let newIndexPaths = newIndexPaths {
            self.selectItemsAtIndexPaths(newIndexPaths)
        }
    }
    
    func selectItemsAtIndexPaths(newIndexPaths:[NSIndexPath]) {
        
        if let currentIndexPaths = self.indexPathsForSelectedItems() {
            for currentIndexPath in currentIndexPaths {
                self.deselectItemAtIndexPath(currentIndexPath, animated: false)
            }
        }
        
        for newIndexPath in newIndexPaths {
            self.selectItemAtIndexPath(newIndexPath, animated: false, scrollPosition: .None)
        }
    }
    
}

