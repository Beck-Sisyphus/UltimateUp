//
//  ViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 3/24/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MainViewController: UIViewController, CLLocationManagerDelegate, UISplitViewControllerDelegate
{
    private var isLogin: Bool? {
        didSet {
            checkLogin()
        }
    }
    var haveDisc: Bool? {
        didSet {
            view.setNeedsDisplay()
        }
    }
    private var isPublic: Bool? {
        didSet {
            
        }
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        self.isLogin = false
//        self.haveDisc = true
//        self.isPublic = false
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.isLogin = false
//        self.haveDisc = true
//        self.isPublic = false
//        super.init(coder: aDecoder)
//    }
    

    @IBOutlet weak var discButtonView: UIBarButtonItem!
    @IBOutlet weak var createGameButtonView: UIButton!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Allow the master view as the first view
        splitViewController?.delegate = self
        
        handleGoogleMap()
        handleNotification()
        
        checkLogin()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        center.removeObserver(self)
    }
    
    @IBAction func createGame(sender: UIButton) {
        if !(isLogin!) {
            // Onboarding
            performSegueWithIdentifier("beforeSignIn", sender: self)
        }
        else {
            // Normal start
            GoogleMap.animateToZoom(16)
        }
    }
    
    func checkLogin() {
        if isLogin == nil {
            print("When the view start, the login is nil", terminator: "\n")
            self.isLogin = false
        }
        print("\(isLogin) in Main view")
        // Onboarding
        if  !(isLogin!) {
            self.title = "UltimateUp"
            createGameButtonView.setTitle("Create Game", forState: UIControlState.Normal)
            self.navigationItem.rightBarButtonItem = nil
        }
            // Normal start
        else {
            self.title = "Do you have discs?"
            createGameButtonView.setTitle("Go Public", forState: UIControlState.Normal)
            self.navigationItem.rightBarButtonItem = self.discButtonView
            afterSignInGoogleMap()
        }
    }
    
    @IBAction func discButton(sender: UIBarButtonItem) {
        
    }
    
    // MARK: Google Map
    private let locationManager = CLLocationManager()
    private var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
    private var latitude: CLLocationDegrees = 47.6550
    private var longitude:CLLocationDegrees = 122.3080
    
    @IBOutlet var GoogleMap: GMSMapView!

    func handleGoogleMap() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = self.desiredAccuracy
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        let camera = GMSCameraPosition.cameraWithLatitude(47.655,
            longitude: -122.308, zoom: 14)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        self.GoogleMap.camera = camera
        self.GoogleMap = mapView
        
//        let placesClient = GMSPlacesClient()
//        placesClient.currentPlaceWithCallback { (placeLikelihoods: GMSPlaceLikelihoodList?, error) in
//            if error != nil {
//                print("can not get current places", terminator: "\n")
//            }   else {
//                if placeLikelihoods != nil {
//                    for likelihood in placeLikelihoods!.likelihoods {
//                        if let likelihood = likelihood as? GMSPlaceLikelihood {
//                            let place = likelihood.place
//                            print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
//                            print("Current Place address \(place.formattedAddress)")
//                            print("Current Place attributions \(place.attributions)")
//                            print("Current PlaceID \(place.placeID)")
//                        }
//                    }
//                }
//            }
//        }
        
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(47.655, -122.308)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
    }
    
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
    
    func afterSignInGoogleMap() {
        
    }
    
    ////    These two methods get current position
    //    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
    //        let currentLocations: [CLLocation]? = locations as? [CLLocation]
    //        if let current = currentLocations as [CLLocation]! {
    //            latitude = current[0].coordinate.latitude
    ////            longitude = current[1].coordinate.longitude
    //        }
    //    }
    
    // MARK: Sign in notification
    let center = NSNotificationCenter.defaultCenter()
    
    func handleNotification() {
        let queue  = NSOperationQueue.mainQueue()
        center.addObserverForName(Constants.Notification.Name, object: nil, queue: queue)
            { notification in
            print("Recieve notification from sign in view controller", terminator: "\n")
            if let isLogin = notification.userInfo?[Constants.Notification.Key] as? Bool {
                self.isLogin = isLogin
            }
        }
    }

    
    // MARK: Let master view comes at first screen
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}




 