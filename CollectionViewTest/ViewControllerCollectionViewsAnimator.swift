//
//  ViewControllerCollectionViewsAnimator.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 22/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerCollectionViewsAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Ensure that we're transitioning in a valid view/window with ViewControllers
        guard let container = transitionContext.containerView(),
            let window = container.window,
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ViewController,
            let fromView = fromVC.view, //transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ViewController,
            let toView = toVC.view else { //transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
        }
        
        // Ensure that we have valid from/to collectionViewTops
        guard let fromCollectionViewTop = fromVC.topCollectionView,
            let toCollectionViewTop = toVC.topCollectionView else {
                return
        }
        
        // Ensure that we have valid from/to collectionViewBottoms
        guard let fromCollectionViewBottom = fromVC.bottomCollectionView,
            let toCollectionViewBottom = toVC.bottomCollectionView else {
                return
        }
        
        // Copy over collectionView delegates to retain consistent focusing behaviour
        self.configureFocusingCollectionView(toCollectionViewTop, withFocusedCollectionView: fromCollectionViewTop, didSelectBlock: toVC.topCollectionViewDidSelectBlock)
        self.configureFocusingCollectionView(toCollectionViewBottom, withFocusedCollectionView: fromCollectionViewBottom, didSelectBlock: toVC.bottomCollectionViewDidSelectBlock)

        let finalViewFrame = transitionContext.finalFrameForViewController(toVC)
        
        let initialRectTop = window.convertRect(fromCollectionViewTop.frame, fromView: fromCollectionViewTop.superview)
        let finalRectTop = toVC.collectionViewFrames(finalViewFrame.size).top
        let topCollectionViewAnimations = self.animateCollectionView((fromCollectionViewTop, toCollectionViewTop), frame:(initialRectTop, finalRectTop))

        let initialRectBottom = window.convertRect(fromCollectionViewBottom.frame, fromView: fromCollectionViewBottom.superview)
        let finalRectBottom = toVC.collectionViewFrames(finalViewFrame.size).bottom
        let bottomCollectionViewAnimations = self.animateCollectionView((fromCollectionViewBottom, toCollectionViewBottom), frame:(initialRectBottom, finalRectBottom))
        
        container.addSubview(toView)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            if let topCollectionViewAnimations = topCollectionViewAnimations {
                topCollectionViewAnimations()
            }
            if let bottomCollectionViewAnimations = bottomCollectionViewAnimations {
                bottomCollectionViewAnimations()
            }
            
        }) { (finished) in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    func configureFocusingCollectionView(collectionView:UICollectionView, withFocusedCollectionView focusedCollectionView:UICollectionView, didSelectBlock:DidSelectBlock) {
        if let focusingDelegate = focusedCollectionView.delegate as? SimpleDelegate {
            collectionView.delegate = focusingDelegate
            if let selectedIndexPaths = focusedCollectionView.indexPathsForSelectedItems() {
                for indexPath in selectedIndexPaths {
                    collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                }
            }
            focusingDelegate.didSelectBlock = didSelectBlock
        }
    }
    
    func animateCollectionView(collectionView: (from:UICollectionView, to:UICollectionView), frame: (initial:CGRect, final:CGRect)) -> (() -> Void)? {
        
        // Ensure that we have valid layouts in collectionViews
        guard let fromLayout = collectionView.from.collectionViewLayout as? UICollectionViewFlowLayout,
            let toLayout = collectionView.to.collectionViewLayout as? UICollectionViewFlowLayout else {
                return nil
        }
        
        let fromCollectionView = collectionView.from
        let toCollectionView = collectionView.to
    
        let fromLayoutCopy = fromLayout.collectionViewFlowLayoutCopy()
        fromCollectionView.setCollectionViewLayout(fromLayoutCopy, animated: false)
        
        var contentInset = toCollectionView.contentInset
        let oldBottomInset = contentInset.bottom
        contentInset.bottom = CGRectGetHeight(frame.final) - (toLayout.itemSize.height + toLayout.sectionInset.bottom + toLayout.sectionInset.top)
        toCollectionView.contentInset = contentInset
        
        toCollectionView.setCollectionViewLayout(fromLayout, animated: false)
        toCollectionView.frame = frame.initial
        toCollectionView.alpha = 0.95
        
        let animations =  {
            toCollectionView.frame = frame.final
            
            toCollectionView .performBatchUpdates({
            
                toCollectionView.setCollectionViewLayout(toLayout, animated: false)
            
                }, completion: { (finished) in
                    toCollectionView.contentInset = UIEdgeInsetsMake(
                        contentInset.top,
                        contentInset.left,
                        oldBottomInset,
                        contentInset.right)
            })
            
            //                    self.topCollectionView.scrollToItemAtIndexPath(topDelegate.focusedIndexPath(self.topCollectionView), atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
            //
            ////                        if let flowLayout = self.topCollectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            ////                            let focusPoint = topDelegate.focussedContentOffset(self.topCollectionView, flowLayout: flowLayout) {
            ////                            let focusRect = CGRectMake(focusPoint.x, focusPoint.y, self.topCollectionView.frame.size.width, self.topCollectionView.frame.size.height)
            ////                            self.topCollectionView.scrollRectToVisible(focusRect, animated: false)
            ////                        }

            
        }
        
        return animations
    }
}