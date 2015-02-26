
//
//  FirstViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 2/12/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import MapKit


class FirstViewController: UIViewController {


    @IBOutlet var mapView:MKMapView? = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let map = MapViewController(frame: mapView!.bounds)
        // let nav = UINavigationController(rootViewController: map)
        // self.window!.rootViewController = nav
        
        // self.window!.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

