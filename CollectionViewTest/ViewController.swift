//
//  ViewController.swift
//  CollectionViewTest
//
//  Created by Kent Humphries on 5/08/2016.
//  Copyright © 2016 KentHumphries. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var topCollectionView: UICollectionView!

    @IBOutlet var bottomCollectionView: UICollectionView!
    
    let singleFlowLayout = SingleFlowLayout()
    var nextFlowLayout : UICollectionViewLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextFlowLayout = singleFlowLayout
        
    }

}

