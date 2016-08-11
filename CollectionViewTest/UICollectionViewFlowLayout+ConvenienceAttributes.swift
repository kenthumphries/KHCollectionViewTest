//
//  UICollectionViewFlowLayout+ConvenienceAttributes.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 11/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    func frameForItemAtIndexPath(indexPath: NSIndexPath) -> CGRect? {
        return self.layoutAttributesForItemAtIndexPath(indexPath)?.frame
    }
    
    func centerForItemAtIndexPath(indexPath: NSIndexPath) -> CGPoint? {
        return self.layoutAttributesForItemAtIndexPath(indexPath)?.center
    }
    
}