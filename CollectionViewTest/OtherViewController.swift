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
    
    override var topCollectionViewDidSelectBlock: DidSelectBlock {
        return { (layout, indexPath) in
            self.performSegueWithIdentifier("Unwind", sender: nil)
        }
    }

    override var bottomCollectionViewDidSelectBlock: DidSelectBlock {
        return { (layout, indexPath) in
            self.navigationController!.popViewControllerAnimated(true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topFlowLayout = UICollectionViewFlowLayout().configureForSingleItemFlow(inCollectionView: self.topCollectionView)
        self.topCollectionView.collectionViewLayout = topFlowLayout

        let bottomFlowLayout = UICollectionViewFlowLayout().configureForSingleItemFlow(inCollectionView: self.bottomCollectionView)
        self.bottomCollectionView.collectionViewLayout = bottomFlowLayout
    }
}