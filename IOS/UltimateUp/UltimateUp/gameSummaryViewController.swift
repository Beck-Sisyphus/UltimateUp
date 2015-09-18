//
//  gameSummaryViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 9/17/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit

class gameSummaryViewController: UIViewController {
    var haveDisc: Bool = true {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        
    }
}
