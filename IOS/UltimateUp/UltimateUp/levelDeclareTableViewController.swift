//
//  levelDeclareTableViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 9/17/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit

class levelDeclareTableViewController: UITableViewController {

    @IBOutlet weak var star0: UITableViewCell!
    @IBOutlet weak var star1: UITableViewCell!
    @IBOutlet weak var star2: UITableViewCell!
    @IBOutlet weak var star3: UITableViewCell!
    @IBOutlet weak var star4: UITableViewCell!
    @IBOutlet weak var star5: UITableViewCell!
    
    // MARK: - Notification sent
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cellCliked = tableView.cellForRowAtIndexPath(indexPath) {
            var level: Int
            switch cellCliked {
            case star0: level = 0
            case star1: level = 1
            case star2: level = 2
            case star3: level = 3
            case star4: level = 4
            case star5: level = 5
            default:    level = -1
            }
            let notification: NSNotification = NSNotification(name: Constants.Level.Name, object: self, userInfo: [Constants.Level.Key: level])
            let center = NSNotificationCenter.defaultCenter()
            center.postNotification(notification)
        }
    }
}
