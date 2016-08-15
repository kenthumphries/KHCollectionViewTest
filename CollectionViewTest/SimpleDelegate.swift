//
//  SimpleDelegate.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 10/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

class SimpleDelegate: NSObject, UICollectionViewDelegateFlowLayoutFocusing // Ensure that the CollectionView is Focusing
{
    
    var didSelectBlock : (collectionViewFlowLayout: UICollectionViewFlowLayout, indexPath: NSIndexPath) -> () = { (layout, indexPath) in
        // Do nothing by default
    }
    
    var focusedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
}

extension SimpleDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let currentLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        self.didSelectBlock(collectionViewFlowLayout: currentLayout, indexPath: indexPath)
    }
}

// MARK: Call UICollectionViewDelegateFlowLayoutFocusing methods on scrolling or external contentOffset change
extension SimpleDelegate {
    /* This should ideally be an extension of UICollectionViewDelegate where Self:UICollectionViewDelegateFlowLayoutFocusing.
       This could then be stored in UICollectionViewDelegateFlowLayoutFocusing and defined once for ALL UICollectionViewDelegateFlowLayoutFocusing objects.
       Alas, this does not work in Swift 2.2 (http://stackoverflow.com/questions/32542362/swift-2-0-uitextfielddelegate-protocol-extension-not-working) */
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionViewDidEndScrolling(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.collectionViewDidEndScrolling(scrollView)
    }
    
    func collectionView(collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return self.focussedContentOffset(collectionView, proposedContentOffset: proposedContentOffset)
    }
}