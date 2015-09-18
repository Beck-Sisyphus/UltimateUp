//
//  userProfileTableViewCell.swift
//  UltimateUp
//
//  Created by Beck Pang on 9/15/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class userProfileTableViewCell: UITableViewCell
{
    @IBOutlet weak var friendsPicImageView: UIImageView!
    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var friendsLevelLabel: UILabel!
    
    // MARK: Local friend profile
    
    var friend: userProfile? {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        // reset any existing friends info
        friendsPicImageView?.image = nil
        friendsNameLabel?.text = nil
        friendsLevelLabel?.text = nil
        
        if let friend = self.friend
        {
            friendsNameLabel?.text = friend.name
            friendsLevelLabel?.text = friend.id
        }
    }
}
