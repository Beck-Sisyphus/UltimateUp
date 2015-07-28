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
    var userName: String? = "" {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var ProfileCell: UITableViewCell!
    
    // MARK: View Controller Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken().hasGranted("public_profile")) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

                if ((error) != nil)
                {
                    print("Error: \(error)", appendNewline: true)
                }
                else
                {
                    let currentResult = result.valueForKey("name") as! String
                    self.userName = currentResult
                }
            })
        }
    }
    //                dispatch_async(dispatch_get_main_queue()) { () -> Void in
    //                }
    
    func updateUI() {
        let FBNameLabel = UILabel(frame: CGRectMake(140, 50, 120, 20))
        FBNameLabel.tag = 1
        FBNameLabel.font = UIFont.systemFontOfSize(18)
        FBNameLabel.textAlignment = NSTextAlignment.Left
        FBNameLabel.textColor = UIColor.blackColor()
        FBNameLabel.text = self.userName
        ProfileCell.addSubview(FBNameLabel)
        
        let FBPicture = FBSDKProfilePictureView(frame: CGRectMake(0, 0, 120, 120))
        ProfileCell.addSubview(FBPicture)
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
