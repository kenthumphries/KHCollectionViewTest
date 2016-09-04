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

public protocol UICollectionViewDelegateFlowLayoutFocusing: NSObjectProtocol {
    
    var lastViewedIndexPath: NSIndexPath { get set }
    
    // Must be called by collectionView
    func collectionViewDidEndScrolling(scrollView: UIScrollView)
    func targetContentOffset(collectionView: UICollectionView, proposedContentOffset: CGPoint) -> CGPoint
    
    // Customisation points
    func viewedIndexPath(collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout) -> NSIndexPath
    func focusedIndexPath(collectionView: UICollectionView) -> NSIndexPath
}

// MARK: Default implementations
extension UICollectionViewDelegateFlowLayoutFocusing {
    
    func collectionViewDidEndScrolling(scrollView: UIScrollView) {
        
        if let collectionView = scrollView as? UICollectionView,
            flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            self.lastViewedIndexPath = self.viewedIndexPath(collectionView, flowLayout: flowLayout)
        }
    }
    
    func viewedIndexPath(collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout) -> NSIndexPath {
        
        // Find the first cell that's at least half visible
        let visibleIndexPaths = collectionView.sortedIndexPathsForVisibleItems()
        for indexPath in visibleIndexPaths {
            if let center = flowLayout.centerForItemAtIndexPath(indexPath) where center > collectionView.contentOffset {
                return indexPath
            }
        }
        return lastViewedIndexPath
    }
    
    func focusedIndexPath(collectionView: UICollectionView) -> NSIndexPath {
        var focusedIndexPath = self.lastViewedIndexPath
        
        if let firstVisibleSelectedIndexPath = collectionView.firstVisibleSelectedIndexPath() {
            // One of the selected cels is visible, so use it for the focus instead
            focusedIndexPath = firstVisibleSelectedIndexPath
        }
        return focusedIndexPath
    }
    
    func targetContentOffset(collectionView: UICollectionView, proposedContentOffset: CGPoint) -> CGPoint {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            focusedContentOffset = self.focusedContentOffset(collectionView, flowLayout: flowLayout) else {
                return proposedContentOffset
        }
        
        return focusedContentOffset
    }
    
    func focusedContentOffset(collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout) -> CGPoint? {
        
        let focusedIndexPath = self.focusedIndexPath(collectionView)
        
        guard let frame = flowLayout.frameForItemAtIndexPath(focusedIndexPath) where frame != CGRectZero else {
            return nil
        }
        
        let spacing = flowLayout.minimumLineSpacing * 0.5
        let margin: (x: CGFloat, y: CGFloat) = flowLayout.scrollDirection == .Horizontal ? (spacing, 0.0) : (0.0, spacing)
        let originX = max(0, frame.origin.x - margin.x)
        let originY = max(0, frame.origin.y - margin.y)
        
        let maxContentOffsetX = collectionView.contentSize.width  - collectionView.frame.size.width
        let maxContentOffsetY = collectionView.contentSize.height - collectionView.frame.size.height

        let focusedContentOffset = CGPointMake(min(originX, maxContentOffsetX), min(originY, maxContentOffsetY))
        return focusedContentOffset
    }
}