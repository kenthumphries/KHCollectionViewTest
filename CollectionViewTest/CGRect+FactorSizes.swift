//
//  CGRect+FactorSizes.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 21/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit

extension CGRect {
    
    func rect(heightMultipliedByFactor factor:CGFloat, x:CGFloat? = nil, y:CGFloat? = nil, width:CGFloat? = nil) -> CGRect {
        return CGRectMake(x ?? origin.x, y ?? origin.y, width ?? size.width, size.height * factor)
    }
}

extension CGRect {

    func rect(widthMultipliedByFactor factor:CGFloat, x:CGFloat? = nil, y:CGFloat? = nil, height:CGFloat? = nil) -> CGRect {
        
        return CGRectMake(x ?? origin.x, y ?? origin.y, size.width * factor, height ?? size.height)
    }
}