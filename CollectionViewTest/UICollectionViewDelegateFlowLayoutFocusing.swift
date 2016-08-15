//
//  UICollectionViewDelegateFlowLayoutFocusing.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 15/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

func >(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.x > rhs.x && lhs.y > rhs.y
}

public protocol UICollectionViewDelegateFlowLayoutFocusing: UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var focusedIndexPath: NSIndexPath { get set }
    
    // Must be called by collectionView
    func collectionViewDidEndScrolling(scrollView: UIScrollView)
    func focussedContentOffset(collectionView: UICollectionView, proposedContentOffset: CGPoint) -> CGPoint
    // Customisation point
    func indexPathToFocusOn(collectionView collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout) -> NSIndexPath?
}

// MARK: Default implementations
extension UICollectionViewDelegateFlowLayoutFocusing {
    
    func collectionViewDidEndScrolling(scrollView: UIScrollView) {
        
        guard let collectionView = scrollView as? UICollectionView,
            flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if let indexPathToFocusOn = self.indexPathToFocusOn(collectionView: collectionView, flowLayout: flowLayout) {
            self.focusedIndexPath = indexPathToFocusOn
        }
    }
    
    func indexPathToFocusOn(collectionView collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout) -> NSIndexPath? {
        
        var indexPathToFocusOn = self.focusedIndexPath // If a new focus can't be found, default to last focus
        
        let visibleIndexPaths = collectionView.sortedIndexPathsForVisibleItems()
        
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems(),
            visibleSelectedIndexPath = NSArray(array: visibleIndexPaths).firstObjectCommonWithArray(selectedIndexPaths) as? NSIndexPath {
            // One of the selected cels is visible, so use it for the focus
            indexPathToFocusOn = visibleSelectedIndexPath
        } else {
            // No selected visible cells, find the first cell that's at least half visible
            for indexPath in visibleIndexPaths {
                if let center = flowLayout.centerForItemAtIndexPath(indexPath) where center > collectionView.contentOffset {
                    indexPathToFocusOn = indexPath
                    break;
                }
            }
        }
        
        return indexPathToFocusOn
    }
    
    func focussedContentOffset(collectionView: UICollectionView, proposedContentOffset: CGPoint) -> CGPoint {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            focusedPoint = self.focussedContentOffset(flowLayout: flowLayout) else {
                return proposedContentOffset
        }
        
        return focusedPoint
    }
    
    func focussedContentOffset(flowLayout flowLayout: UICollectionViewFlowLayout) -> CGPoint? {
        
        guard let frame = flowLayout.frameForItemAtIndexPath(focusedIndexPath) where frame != CGRectZero else {
            return nil
        }
        
        let originX = max(0, frame.origin.x - flowLayout.minimumInteritemSpacing)
        let originY = max(0, frame.origin.y - flowLayout.minimumInteritemSpacing)
        return CGPointMake(originX, originY)
    }
}