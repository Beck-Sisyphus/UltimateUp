//
//  ViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 3/24/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    // For two view transaction
    var isSignIn: Bool = false {
        didSet {
            title = "\(isSignIn)"
        }
    }
    
    private var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
    private var latitude: CLLocationDegrees = 47.6550
    private var longitude:CLLocationDegrees = 122.3080
    private let locationManager = CLLocationManager()
    

    @IBOutlet var GoogleMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = self.desiredAccuracy
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        var camera = GMSCameraPosition.cameraWithLatitude(47.655,
            longitude: -122.308, zoom: 14)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        // self.view = mapView
        // self.view.addSubview(GoogleMap)
        // self.GoogleMap = mapView
        self.GoogleMap.camera = camera

        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(47.655, -122.308)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    @IBAction func createGame(sender: UIButton) {
        println("\(latitude)")
        println("\(longitude)")
        performSegueWithIdentifier("createGame", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // pull out a UIViewController from a NavigationController
        var destination = segue.destinationViewController as? UIViewController
        if let navControler = destination as? UINavigationController {
            destination = navControler.visibleViewController
        }
        
        if let vc = destination as? createGameController{
            if let identifier = segue.identifier {
                switch identifier {
                case "createGame": vc.setting = true
                default: break
                }
            }
        }
    }
    
    // These two methods get current position
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLocations: [CLLocation]? = locations as? [CLLocation]
        if let current = currentLocations as [CLLocation]! {
            latitude = current[0].coordinate.latitude
            longitude = current[1].coordinate.longitude
            
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        manager.requestWhenInUseAuthorization()
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to find Frisbee players near you, please open this app's settings and set location access to 'While Using the App'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

 