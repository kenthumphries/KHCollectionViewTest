//
//  SimpleDelegate.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 10/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

func >(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.x > rhs.x && lhs.y > rhs.y
}

class SimpleDelegate: NSObject, UICollectionViewDelegate {

    var selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    var focussedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndScrolling(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrolling(scrollView)
    }
    
    func scrollViewDidEndScrolling(scrollView: UIScrollView) {
    
        guard let collectionView = scrollView as? UICollectionView,
            flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let visibleIndexPaths = collectionView.sortedIndexPathsForVisibleItems()
        
        for indexPath in visibleIndexPaths {
            if let center = flowLayout.centerForItemAtIndexPath(indexPath) where center > collectionView.contentOffset {
                print("FocussedIndexPath = \(indexPath)")
                focussedIndexPath = indexPath
                break;
            }
        }
    }

    func collectionView(collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return proposedContentOffset
        }
        
        let collectionViewName = collectionView.tag == 0 ? "TopCV" : "BottomCV"
        print(collectionViewName + " Proposed Content Offset: \(NSStringFromCGPoint(proposedContentOffset))")
        var contentOffset = proposedContentOffset
        
        // Determine whether to focus on selectedIndexPath or scrolledIndexPath
        let indexPathToFocusOn: NSIndexPath
        if collectionView.indexPathsForVisibleItems().contains(selectedIndexPath) {
            indexPathToFocusOn = selectedIndexPath
        } else {
            indexPathToFocusOn = focussedIndexPath
        }
        
        if let frame = flowLayout.frameForItemAtIndexPath(indexPathToFocusOn) where frame != CGRectZero {
            let originX = max(0, frame.origin.x - flowLayout.minimumInteritemSpacing)
            let originY = max(0, frame.origin.y - flowLayout.minimumInteritemSpacing)
            contentOffset = CGPointMake(originX, originY)
        }
        
        print(collectionViewName + " Calculated Content Offset: \(NSStringFromCGPoint(contentOffset))")
        print(collectionViewName + " Frame: \(NSStringFromCGRect(collectionView.frame))\n")
        
        return contentOffset
    }

}