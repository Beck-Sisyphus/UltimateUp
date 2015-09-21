//
//  levelTableViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 9/17/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit

class levelTableViewController: UITableViewController {

    @IBOutlet weak var levelLabel: UILabel!
    
    var level: Int = 0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNotification()
        processNotification()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        center.removeObserver(self)
    }
    
    // MARK: - Notification receive
    private let center = NSNotificationCenter.defaultCenter()
//    private var levelObserver: NSObjectProtocol?
    
    private func handleNotification() {
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(Constants.Level.Name, object: nil, queue: queue) { notification in
            if let level = notification.userInfo?[Constants.Level.Key] as? Int {
                self.level = level
            }
        }
    }

    // MARK: - Process and display
    private func processNotification() {
        
    }
}
