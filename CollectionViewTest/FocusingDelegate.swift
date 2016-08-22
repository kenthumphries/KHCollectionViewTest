//
//  FocusingDelegate.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 15/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

class FocusingDelegate: NSObject, UICollectionViewDelegateFlowLayoutFocusing // Ensure that the CollectionView is Focusing
{
    var lastViewedIndexPath: NSIndexPath
    
    override required init() {
         lastViewedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    }
}

// MARK: Call UICollectionViewDelegateFlowLayoutFocusing methods on scrolling and external contentOffset change
extension FocusingDelegate {
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionViewDidEndScrolling(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.collectionViewDidEndScrolling(scrollView)
    }
    
    func collectionView(collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return self.targetContentOffset(collectionView, proposedContentOffset: proposedContentOffset)
    }
}