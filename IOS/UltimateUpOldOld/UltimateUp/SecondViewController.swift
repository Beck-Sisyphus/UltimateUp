//
//  SecondViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 2/12/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Load Facebook Login In button
        var loginView = FBLoginView()
        loginView.center = self.view.center
        self.view.addSubview(loginView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = true
        navigationController?.hidesBarsOnSwipe = true
        
    }

    @IBAction func CallServer(sender: UIButton) {
//        var manager = AFHTTPRequestOperationManager()
//        var parameter: NSDictionary = ["Ultimate": "USA"]
//        var url: NSString = "54.86.169.6/ios/comm_test.php"
//        manager.POST(url, parameters: parameter, success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
//            println(responseObject)
//            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
//            println(error.localizedDescription)
//        })
    }
}

