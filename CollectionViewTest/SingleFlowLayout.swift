//
//  SingleFlowLayout.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 13/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

class SingleFlowLayout : UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    let padding : CGFloat = 10.0
    let cellSizeRatio : CGFloat = 334/375 // This is the ratio of iPhone half height/iPhone width
    
    func cellHeightForCollectionView(collectionView : UICollectionView) -> CGFloat {
        return self.cellWidthForCollectionView(collectionView) * cellSizeRatio
    }
    
    func cellWidthForCollectionView(collectionView : UICollectionView) -> CGFloat {
        return collectionView.frame.size.width - (2 * self.padding)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? SingleFlowLayout else {
            return CGSizeMake(0, 0)
        }
        
        return  CGSizeMake(layout.cellWidthForCollectionView(collectionView),
                           layout.cellHeightForCollectionView(collectionView))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        guard let layout = collectionViewLayout as? SingleFlowLayout else {
            return 0
        }
        
        return layout.padding * 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        guard let layout = collectionViewLayout as? SingleFlowLayout else {
            return 0
        }
        
        return layout.padding * 2
    }
}