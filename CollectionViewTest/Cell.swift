//
//  self.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 10/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

class Cell : UICollectionViewCell {
    
    let title = UILabel()
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            super.selected = newValue
            self.contentView.layer.borderColor = UIColor.greenColor().CGColor
            self.contentView.layer.borderWidth = newValue ? 4.0 : 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.contentView.addSubview(title)

        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.textAlignment = .Center
        let centerXConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[title]|", options: .AlignAllCenterX, metrics: nil, views: ["title":self.title])
        let centerYConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]|", options: .AlignAllCenterY, metrics: nil, views: ["title":self.title])
        
        self.contentView.addConstraints(centerXConstraints)
        self.contentView.addConstraints(centerYConstraints)
    }
    
    
}