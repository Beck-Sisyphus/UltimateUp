
//
//  FriendsTableViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 9/11/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FriendsTableViewController: UITableViewController, UITextFieldDelegate
{
    var friendsNumber = 0
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
        }
        return true
    }

    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        graphRequest.startWithCompletionHandler { connection, result, error in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if ((error) != nil) { print("Error: \(error)", terminator: "\n") }
                else
                {
                    if let friendSummary = result["data"] as? NSMutableArray{
//                        let friendList = friendSummary["members"]
//                        if friendList != nil {
////                            self.friendsNumber = friendList!.count
//                            print("user has \(self.friendsNumber)", terminator: "\n")
//                        }
                        print("\(friendSummary)", terminator: "\n")
                    }
                }
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return friendsNumber
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsNumber
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get the friend's from Facebook
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends",
//            parameters: ["fields": "data"])
//        graphRequest.startWithCompletionHandler{ connection, result, error in
//            
//            if ((error) != nil)
//            {
//                print("Error: \(error)", terminator: "\n")
//            }
//            else
//            {
//                print("Result is: \(result)", terminator: "\n")
//                
//                if let friends = result["data"] as? NSArray {
//                    print("friends\(friends)", terminator: "\n")
//                    for friend in friends {
//                        let friendName = friend["name"] as? NSString
//                        print("friend list:\(friendName)", terminator:"\n")
//                    }
//                }
//            }
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath)
        cell.textLabel?.text = "should be friend's name"
        cell.detailTextLabel?.text = "should be friend's level"
        cell.imageView?.image = nil // should be the image of his friend

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
