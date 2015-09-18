
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
    var friends = [[userProfile]]()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
            }
    
    private func refresh() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        graphRequest.startWithCompletionHandler { connection, result, error in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if ((error) != nil) { print("Error: \(error)", terminator: "\n") }
                else
                {
                    if let startingNode = result.valueForKey("friends") as? NSDictionary{
                        if let friendNode = startingNode.valueForKey("data") as? NSArray{
                            print("The members contains \(friendNode)", terminator: "\n")
                            if let friendData = friendNode[0] as? NSDictionary{
                                let friendId = friendData.valueForKey("id") as? String
                                let friendName = friendData.valueForKey("name") as? String
                                if friendId != nil && friendName != nil {
                                    print("Hopefully we have \(friendName!) with ID of \(friendId!)")
                                    let newfriend = userProfile(data: ["id": friendId!, "name": friendName!])
                                    var friendsInSection = [userProfile]()
                                    friendsInSection.insert(newfriend!, atIndex: 0)
                                    self.friends.insert(friendsInSection, atIndex: 0)
                                    print(self.friends)
                                }
                            }
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return friends.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends[section].count
    }   

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as! userProfileTableViewCell
        cell.friend = friends[indexPath.section][indexPath.row]

        return cell
    }

    // MARK: For search
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
