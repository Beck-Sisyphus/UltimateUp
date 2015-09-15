//
//  SettingViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 7/26/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var facebookAvator: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!


    
    var userName: String? = "" {
        didSet {
            updateUI()
        }
    }
    
    // MARK: View Controller Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken().hasGranted("public_profile")) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":""])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

                if ((error) != nil)
                {
                    print("Error: \(error)", terminator: "\n")
                }
                else
                {
                    let currentResult = result.valueForKey("name") as! String
                    self.userName = currentResult
                }
            })
        }
    }
    
    func updateUI() {
        nameLabel.text = self.userName
        levelLabel.text = "Need to be implement"
        dispatch_async(dispatch_get_main_queue()) {
            let FBPicture = FBSDKProfilePictureView(frame: CGRectMake(0, 0, 120, 120))
            self.facebookAvator = FBPicture
        }
        tableView.reloadData()
    }

}
