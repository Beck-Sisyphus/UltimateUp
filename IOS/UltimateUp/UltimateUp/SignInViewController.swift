//
//  SignInViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 3/22/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct Constants {
    struct Notification {
        static let Name = "is Sign In Name"
        static let Key  = "is Sign In Key"
    }
}

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {


    
    // MARK: Facebook Login

    @IBOutlet var loginButton: FBSDKLoginButton!
    let center = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            loginButton.readPermissions = ["public_profile", "user_education_history"]
            loginButton.delegate = self
            returnUserData()
        }
    } 
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false;
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // default function for LoginButton delegate
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In", terminator: "")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // Post a notification that it is sign in
            
            let notification = NSNotification(name: Constants.Notification.Name, object: self, userInfo: [Constants.Notification.Key: true])
            center.postNotification(notification)
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("public_profile")
            {
                // Turn into another view
                performSegueWithIdentifier("AfterSignIn", sender: self)
            }
        }
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
            parameters: ["fields": "email, friends"])
        graphRequest.startWithCompletionHandler{ connection, result, error in
            
            if ((error) != nil)
            {
                print("Error: \(error)", terminator: "")
            }
            else
            {
                self.performSegueWithIdentifier("AfterSignIn", sender: self)
            }
        }
    }
    
    
    // MARK: Facebook logout
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out", terminator:"")
        let notification = NSNotification(name: Constants.Notification.Name, object: self, userInfo: [Constants.Notification.Key: false])
        center.postNotification(notification)
    }
    

    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // pull out a UIViewController from a NavigationController
        var destination = segue.destinationViewController as UIViewController
        if let navControler = destination as? UINavigationController {
            destination = navControler.visibleViewController!
        }
        
        if let vc = destination as? levelProclaimViewController{
            if let identifier = segue.identifier {
                switch identifier {
                case "AfterSignIn": break // vc.isSignIn = true
                default: break
                }
            }
        }
    }
}