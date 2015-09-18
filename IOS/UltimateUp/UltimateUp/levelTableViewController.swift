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
        removeAllObserver()
    }
    
    // MARK: - Notification receive
    private let center = NSNotificationCenter.defaultCenter()
    private var levelObserver: NSObjectProtocol?
    
    private func handleNotification() {
        let queue = NSOperationQueue.mainQueue()
        levelObserver = center.addObserverForName(Constants.Level.Name, object: nil, queue: queue) { notification in
            if let level = notification.userInfo?[Constants.Level.Key] as? Int {
                self.level = level
            }
        }
    }
    
    private func removeAllObserver() {
        if let observer = levelObserver {
            center.removeObserver(observer)
        }
    }
    
    // MARK: - Process and display
    private func processNotification() {
        
    }
}
