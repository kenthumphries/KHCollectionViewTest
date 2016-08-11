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
}

