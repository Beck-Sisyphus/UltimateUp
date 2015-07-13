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

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // The view navigation part of the code
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // pull out a UIViewController from a NavigationController
        var destination = segue.destinationViewController as? UIViewController
        if let navControler = destination as? UINavigationController {
            destination = navControler.visibleViewController
        }
        
        if let vc = destination as? MainViewController{
            if let identifier = segue.identifier {
                switch identifier {
                    case "AfterSignIn": vc.isSignIn = true
                    default: break
                }
            }
        }
    }
    
    // The Facebook login part of the code

    @IBOutlet var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            loginButton.readPermissions = ["public_profile", "user_education_history"]
            loginButton.delegate = self
            returnUserData()
        }   else {
            // stay here
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false;
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // default function for LoginButton delegate
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In", appendNewline: false)
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("public_profile")
            {
                // Turn into another view
                performSegueWithIdentifier("AfterSignIn", sender: self)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out", appendNewline: false)
    }
    
    func returnUserData()
    {
        // Both Access Token and FB ID needed for sign in process
        print("Access Token is:")
        print(FBSDKAccessToken.currentAccessToken().tokenString)
        print("User ID is:")
        print(FBSDKAccessToken.currentAccessToken().userID)
        print("It's experiation date is:")
        print(FBSDKAccessToken.currentAccessToken().expirationDate)
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)", appendNewline: false)
            }
            else
            {
                print("fetched user: \(result)", appendNewline: false)
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)", appendNewline: false)
                // Call for next view, the Main View
                self.performSegueWithIdentifier("AfterSignIn", sender: self)
            }
        })
    }
}