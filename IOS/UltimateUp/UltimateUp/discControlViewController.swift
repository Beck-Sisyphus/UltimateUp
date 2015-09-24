//
//  discControlViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 9/17/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit



class discControlViewController: UIViewController {
    // MARK: - Notification sent
    private let center = NSNotificationCenter.defaultCenter()
    
    @IBAction func haveDiscButton(sender: UIButton) {
        let notification = NSNotification(name: Constants.DiscValue.Name, object: self, userInfo: [Constants.DiscValue.Key: true])
        center.postNotification(notification)
    }

    @IBAction func donotHaveDiscButton(sender: UIButton) {
        let notification = NSNotification(name: Constants.DiscValue.Name, object: self, userInfo: [Constants.DiscValue.Key: false])
        center.postNotification(notification)
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // pull out a UIViewController from a NavigationController
        var destination = segue.destinationViewController as UIViewController
        if let navControler = destination as? UINavigationController {
            destination = navControler.visibleViewController!
        }
        if let mainView = destination as? MainViewController{
            if let identifier = segue.identifier {
                if identifier == "haveDisc" {
                    mainView.isLogin = true
                    mainView.haveDisc = true
                } else if identifier == "notHaveDisc" {
                    mainView.isLogin = true
                    mainView.haveDisc = false
                }
            }
        }
    }
}
