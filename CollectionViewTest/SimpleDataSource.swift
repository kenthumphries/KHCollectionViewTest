//
//  SimpleDataSource.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 6/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    static func randomValue(pastel pastel: Bool? = false) -> CGFloat {
        let colorspace = UInt32(256)
        let random = CGFloat(arc4random()%colorspace)
        // Map random to values between 0.00 and 1.00
        var normalised = (1.0 / CGFloat(colorspace)) * random
        if let pastel = pastel where pastel == true {
            // Map Random to values between 0.00 and 0.40
            normalised = 0.40 * normalised
            // Add 0.5 to return values between 0.55 and 0.95 (pastel color space
            normalised += 0.55
        }
        return normalised
    }
    
    static func random(red red: CGFloat? = -1.0, green: CGFloat? = -1.0, blue: CGFloat? = -1.0) -> UIColor {
        
        var redRandom = self.randomValue(pastel:true)
        if let red = red where red >= 0.0 {
            redRandom = red
        }

        var greenRandom = self.randomValue(pastel:true)
        if let green = green where green >= 0.0 {
            greenRandom = green
        }

        var blueRandom = self.randomValue(pastel:true)
        if let blue = blue where blue >= 0.0 {
            blueRandom = blue
        }

        return UIColor(red: redRandom, green: greenRandom, blue: blueRandom, alpha: 1.0)
    }
}

class SimpleDataSource: NSObject, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellReuseIdentifier", forIndexPath: indexPath)
        
        if let cell = cell as? Cell {
            
            cell.title.text = "\(indexPath.section).\(indexPath.item)"
            cell.title.sizeToFit()
            
            if (collectionView.tag == 0) {
                cell.contentView.backgroundColor = UIColor.random(red: 1.00) // Make random self color, but red-ish
            } else {
                cell.contentView.backgroundColor = UIColor.random(green: 1.00) // Make random self color, but green-ish
            }
            
            let totalItems = collectionView.numberOfItemsInSection(indexPath.section)
            // Make cells fading in opacity down to 0.25 for last item
            // First quarter of items will be > 1.0 which is interpreted as 1.00
            let alpha = 1.25 - (CGFloat(indexPath.item) / CGFloat(totalItems))
            cell.contentView.backgroundColor = cell.contentView.backgroundColor?.colorWithAlphaComponent(alpha)
        }
        
        return cell
    }
}