//
//  UICollectionView+Synchronize.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 4/09/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func synchroniseSelectedItems(fromCollectionView collectionView:UICollectionView) {
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems() {
            for indexPath in selectedIndexPaths {
                self.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        }
    }
}