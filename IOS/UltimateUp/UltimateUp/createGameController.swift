//
//  createGameController.swift
//  UltimateUp
//
//  Created by Beck Pang on 5/14/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit

class createGameController: UITableViewController {
    var setting: Bool = false {
        didSet {
            title = "\(setting)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }
}
