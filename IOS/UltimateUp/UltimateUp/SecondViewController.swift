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

    @IBAction func SignInButton(sender: UIButton) {
        sender.setTitle("test", forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

