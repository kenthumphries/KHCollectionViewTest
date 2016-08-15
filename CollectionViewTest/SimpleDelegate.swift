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