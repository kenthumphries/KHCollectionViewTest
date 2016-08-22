//
//  UICollectionViewFlowLayout+collectionViewFlowLayoutCopy.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 22/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout {
    
    func collectionViewFlowLayoutCopy() -> UICollectionViewFlowLayout {
    
        let copy = UICollectionViewFlowLayout()
        
        copy.itemSize = self.itemSize
        copy.sectionInset = self.sectionInset
        copy.minimumInteritemSpacing = self.minimumInteritemSpacing
        copy.minimumLineSpacing = self.minimumLineSpacing
        copy.scrollDirection = self.scrollDirection
        
        return copy
    }
}