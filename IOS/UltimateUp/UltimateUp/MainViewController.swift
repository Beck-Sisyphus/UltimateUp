//
//  ViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 3/24/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var isSignIn: Bool = false {
        didSet {
            title = "\(isSignIn)"
        }
    }
    
    @IBOutlet var GoogleMap: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}

 