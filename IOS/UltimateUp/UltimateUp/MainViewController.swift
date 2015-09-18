//
//  ViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 3/24/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, UISplitViewControllerDelegate {

    // MARK: Google Map
    private var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
    private var latitude: CLLocationDegrees = 47.6550
    private var longitude:CLLocationDegrees = 122.3080
    private let locationManager = CLLocationManager()
    private var isSignIn = false
    
    @IBOutlet var GoogleMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Allow the master view as the first view
        splitViewController?.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = self.desiredAccuracy
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        let camera = GMSCameraPosition.cameraWithLatitude(47.655,
            longitude: -122.308, zoom: 14)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        // self.view = mapView
        // self.view.addSubview(GoogleMap)
        // self.GoogleMap = mapView
        self.GoogleMap.camera = camera

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(47.655, -122.308)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        // MARK: Global Notification
        let center = NSNotificationCenter.defaultCenter()
        let queue  = NSOperationQueue.mainQueue()
        center.addObserverForName(Constants.Notification.Name, object: nil
//            UIApplication.sharedApplication().SignInViewController?
            , queue: queue)
        { notification in
            print("Recieve notification from sign in view controller", terminator: "\n")
            if let isSignIn = notification.userInfo?[Constants.Notification.Key] as? Bool {
                self.isSignIn = isSignIn
            }
        }
    }
    
    @IBAction func createGame(sender: UIButton) {
//        print("\(latitude)", appendNewline: false)
//        print("\(longitude)", appendNewline: false)
        if isSignIn {
            performSegueWithIdentifier("afterSignIn", sender: self)
        }
        else {
            performSegueWithIdentifier("beforeSignIn", sender: self)
        }
    }

    // These two methods get current position
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
//        let currentLocations: [CLLocation]? = locations as? [CLLocation]
//        if let current = currentLocations as [CLLocation]! {
//            latitude = current[0].coordinate.latitude
////            longitude = current[1].coordinate.longitude
//        }
//    }
//    
    func locationManager(manager: CLLocationManager,
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    // MARK: Let master view comes at first screen
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}




 