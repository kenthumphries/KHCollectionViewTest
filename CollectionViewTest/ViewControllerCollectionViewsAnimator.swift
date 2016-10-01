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
    
    var animationCenters: AnimationCenters
    
    override init() {
        self.animationCenters = (CGPointZero, CGPointZero)
    }
    
    convenience init(animationCenters:AnimationCenters?) {
        self.init()
        
        if let animationCenters = animationCenters {
            self.animationCenters = animationCenters
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Ensure that we're transitioning in a valid view/window with ViewControllers
        let container = transitionContext.containerView()
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
        }
        
        let subviewActions = animateSubviews(transitionContext, containerView:container)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext),
                                   animations: {
                                    subviewActions?.animations()
        }) { (finished) in
            container.insertSubview(toView, aboveSubview: fromView)
            fromView.removeFromSuperview()
            
            subviewActions?.completion()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    func animateSubviews(transitionContext:UIViewControllerContextTransitioning,
                         containerView container:UIView) -> (animations:(() -> Void), completion:(() -> Void))? {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ViewController,
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ViewController else {
                return nil
        }
        
        // Ensure that we have valid from/to collectionViewTops & Bottoms
        guard let fromCollectionViewTop = fromVC.topCollectionView,
            let toCollectionViewTop = toVC.topCollectionView,
            let fromCollectionViewBottom = fromVC.bottomCollectionView,
            let toCollectionViewBottom = toVC.bottomCollectionView else {
                return nil
        }
        
        // Get animation & completion blocks for animating each collectionView
        let topCollectionViewAsynchActions = self.animateCollectionView((fromCollectionViewTop, toCollectionViewTop),
                                                                        animationCenter: self.animationCenters.top,
                                                                        containerView: container)
        
        let bottomCollectionViewAsynchActions = self.animateCollectionView((fromCollectionViewBottom, toCollectionViewBottom),
                                                                           animationCenter: self.animationCenters.bottom,
                                                                           containerView: container)
        
        let asyncAnimations = {
            topCollectionViewAsynchActions?.animations()
            bottomCollectionViewAsynchActions?.animations()
        }
        let asyncCompletion = {
            topCollectionViewAsynchActions?.completion()
            bottomCollectionViewAsynchActions?.completion()
        }
        return (asyncAnimations, asyncCompletion)
    }
    
    func animateCollectionView(collectionView:(from:UICollectionView, to:UICollectionView),
                               animationCenter: CGPoint?,
                               containerView container:UIView) -> (animations:(() -> Void), completion:(() -> Void))? {
        
        let initialRect = container.convertRect(collectionView.from.frame, fromView: collectionView.from.superview)
        let finalRect = container.convertRect(collectionView.to.frame, fromView: collectionView.to.superview)

        return self.animateFromCollectionView(collectionView, animationCenter: animationCenter, frame:(initialRect, finalRect))
        
    }
    
    func animateFromCollectionView(collectionView: (from:UICollectionView, to:UICollectionView),
                                   animationCenter: CGPoint?,
                                   frame: (initial:CGRect, final:CGRect)) -> (animations:(() -> Void), completion:(() -> Void))? {
        
        // Ensure that we have valid layouts in collectionViews
        guard let fromLayout = collectionView.from.collectionViewLayout as? UICollectionViewFlowLayout,
            let toLayout = collectionView.to.collectionViewLayout as? UICollectionViewFlowLayout else {
                return nil
        }
        
        let toLayoutCopy = toLayout.collectionViewFlowLayoutCopy()
        let fromCollectionView = collectionView.from
        
        // Create a snapshot of fromCollectionView and add this behind the actual collectionView
        if let snapshot = fromCollectionView.snapshotViewAfterScreenUpdates(false) {
            
            // Make collectionView transparent so we can see behind it
            let backgroundColor = fromCollectionView.backgroundColor
            fromCollectionView.backgroundColor = UIColor.clearColor()

            let snapshotContainer = UIView()
            snapshotContainer.clipsToBounds = true
            snapshotContainer.frame = frame.initial
            snapshotContainer.backgroundColor = backgroundColor
            snapshotContainer.addSubview(snapshot)
            
            if let animationCenter = animationCenter {
                let snapshotLayerFrame = snapshot.layer.frame
                snapshot.layer.anchorPoint = CGPointMake(animationCenter.x / snapshotLayerFrame.size.width, animationCenter.y / snapshotLayerFrame.size.height)
                snapshot.layer.frame = snapshotLayerFrame
            }
            
            fromCollectionView.superview?.insertSubview(snapshotContainer, belowSubview: fromCollectionView)
            
            // Set a large bottomContentInset to avoid any issues when switching to new layout in animation block
            let originalContentInset = fromCollectionView.contentInset
            var adjustedContentInset = originalContentInset
            adjustedContentInset.bottom = CGRectGetHeight(frame.final) - (toLayout.itemSize.height + toLayout.sectionInset.bottom + toLayout.sectionInset.top)
            fromCollectionView.contentInset = adjustedContentInset
            
            let animations =  {
                fromCollectionView.frame = frame.final
                snapshotContainer.frame = frame.final
                fromCollectionView.backgroundColor = backgroundColor
                snapshot.transform = CGAffineTransformMakeScale(5.0, 5.0)
                
                fromCollectionView.performBatchUpdates({
                    
                    fromCollectionView.setCollectionViewLayout(toLayoutCopy, animated: false)
                    
                    }, completion:nil
                )
            }
            
            let completion = {
                let finalContentOffset = fromCollectionView.contentOffset
                fromCollectionView.frame = frame.initial
                snapshotContainer.removeFromSuperview()
                fromCollectionView.contentInset = originalContentInset
                fromCollectionView.setCollectionViewLayout(fromLayout, animated: false)
                collectionView.to.setContentOffset(finalContentOffset, animated: false)
            }
            
            return (animations, completion)
        }
        return nil
    }
        
//    func animateToCollectionView(collectionView: (from:UICollectionView, to:UICollectionView), frame: (initial:CGRect, final:CGRect)) -> (animations:(() -> Void), completion:(() -> Void))? {
//        
//        // Ensure that we have valid layouts in collectionViews
//        guard let fromLayout = collectionView.from.collectionViewLayout as? UICollectionViewFlowLayout,
//            let toLayout = collectionView.to.collectionViewLayout as? UICollectionViewFlowLayout else {
//                return nil
//        }
//        
//        let fromCollectionView = collectionView.from
//        let toCollectionView = collectionView.to
//        
//        let fromLayoutCopy = fromLayout.collectionViewFlowLayoutCopy()
//        fromCollectionView.setCollectionViewLayout(fromLayoutCopy, animated: false)
//        
//        let originalContentInset = toCollectionView.contentInset
//        var adjustedContentInset = originalContentInset
//        adjustedContentInset.bottom = CGRectGetHeight(frame.final) - (toLayout.itemSize.height + toLayout.sectionInset.bottom + toLayout.sectionInset.top)
//        toCollectionView.contentInset = adjustedContentInset
//        
//        toCollectionView.setCollectionViewLayout(fromLayout, animated: false)
//        toCollectionView.frame = frame.initial
//        
//        let animations =  {
//            toCollectionView.frame = frame.final
//            
//            toCollectionView .performBatchUpdates({
//                
//                toCollectionView.setCollectionViewLayout(toLayout, animated: false)
//                
//                }, completion: { (finished) in
//                    toCollectionView.contentInset = originalContentInset
//            })
//        }
//        
//        return (animations, {})
//    }

}
