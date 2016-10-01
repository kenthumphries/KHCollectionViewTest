//
//  OtherViewController.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 22/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import Foundation
import UIKit

class OtherViewController: ViewController {
    
    override var topCollectionViewFactor: CGFloat { return 0.666 }
    
    override var segueIdentifier: String { return "Unwind" }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topFlowLayout = UICollectionViewFlowLayout().configureForSingleItemFlow(inCollectionView: self.topCollectionView)
        topFlowLayout.scrollDirection = .Horizontal
        self.topCollectionView.collectionViewLayout = topFlowLayout

        let bottomFlowLayout = UICollectionViewFlowLayout().configureForSingleItemFlow(inCollectionView: self.bottomCollectionView)
        bottomFlowLayout.scrollDirection = .Vertical
        self.bottomCollectionView.collectionViewLayout = bottomFlowLayout
    }
}