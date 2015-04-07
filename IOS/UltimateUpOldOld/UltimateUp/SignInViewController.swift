//
//  SignInViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 2/19/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
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
        navigationController?.navigationBarHidden = false;
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
}