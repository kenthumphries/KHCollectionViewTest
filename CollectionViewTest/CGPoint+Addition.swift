//
//  CGPoint+Addition.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 7/09/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit

extension CGPoint {

    func adding(point:CGPoint) -> CGPoint {
        return CGPointMake(self.x + point.x, self.y + point.y)
    }
    
    func subtracting(point:CGPoint) -> CGPoint {
        return CGPointMake(self.x - point.x, self.y - point.y)
    }
}