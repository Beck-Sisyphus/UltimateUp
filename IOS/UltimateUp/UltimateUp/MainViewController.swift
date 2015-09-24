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

class MainViewController: UIViewController, CLLocationManagerDelegate, UISplitViewControllerDelegate,
    GMSMapViewDelegate
{
    var isLogin: Bool = false {
        didSet {
            view.setNeedsDisplay()
        }
    }
    
    var haveDisc: Bool = false {
        didSet {
            view.setNeedsDisplay()
            discSwitch?.setOn(haveDisc, animated: true)
        }
    }
    private var isPublic: Bool = false {
        didSet {
            checkPublicState()
        }
    }
    private var estimateTime: NSDateComponents? {
        didSet {
            
        }
    }

    @IBOutlet weak var discSwitch: UISwitch!
    @IBOutlet weak var createGameButtonView: UIButton!
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Allow the master view as the first view
        splitViewController?.delegate = self
        handleLocationManager()
        handleGoogleMapAPI()
        handleGooglePlaceAPI()
        
        estimateTime?.minute = 5
        checkLoginState()
        afterSignInGoogleMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        handleNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        center.removeObserver(self)
    }
    
    @IBAction func createGame(sender: UIButton) {
        if !(isLogin) {
            // Onboarding
            performSegueWithIdentifier("beforeSignIn", sender: self)
        }
        else {
            // Normal start
            googleMap.animateToZoom(16)
            isPublic = true
        }
    }
    
    func checkLoginState() {
        // Onboarding
        if  !(isLogin) {
            self.title = "UltimateUp"
            nameLabel.hidden = true
            addressLabel.hidden = true
            createGameButtonView.setTitle("Create Game", forState: UIControlState.Normal)
            self.navigationItem.rightBarButtonItem = nil
            
        }  else {
            self.title = "Do you have discs?"
            nameLabel.hidden = false
            addressLabel.hidden = false
            createGameButtonView.setTitle("Go Public", forState: UIControlState.Normal)
            self.navigationItem.rightBarButtonItem = self.rightBarItem
        }
    }

    private func checkPublicState() {
        if isPublic {
            self.title = "UltimateUp"
            createGameButtonView.setTitle("Estimate time \(estimateTime)", forState: UIControlState.Normal)
        }
    }
    
    // MARK: Google Map
    private let locationManager = CLLocationManager()
    private var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
    private var latitude: CLLocationDegrees = 47.6550
    private var longitude:CLLocationDegrees = 122.3080
    
    @IBOutlet weak var googleMap: GMSMapView!
    private var placesClient: GMSPlacesClient?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private func handleLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = self.desiredAccuracy
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func handleGoogleMapAPI() {
        // Bring the button to the front of GMSVectorView
        googleMap.bringSubviewToFront(createGameButtonView)
        googleMap.bringSubviewToFront(nameLabel)
        googleMap.bringSubviewToFront(addressLabel)
        let camera = GMSCameraPosition.cameraWithLatitude(47.655, longitude: -122.308, zoom: 14)
        googleMap.camera = camera
        googleMap.myLocationEnabled = true
        googleMap.settings.compassButton = true
        googleMap.settings.myLocationButton = true
        googleMap.delegate = self
    }
    
    private func handleGooglePlaceAPI() {
        placesClient = GMSPlacesClient()
        placesClient?.currentPlaceWithCallback { (placeLikelihoodList: GMSPlaceLikelihoodList?, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)", terminator: "\n")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLicklihoodList = placeLikelihoodList {
                let place = placeLicklihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress.componentsSeparatedByString(", ").joinWithSeparator("\n")
                }
            }
        }
        
        let centerPoint = googleMap.center
        let centerCoordinate = googleMap.projection.coordinateForPoint(centerPoint)
//        let northEast = CLLocationCoordinate2DMake(centerCoordinate.latitude + 0.001, centerCoordinate.longitude + 0.001)
//        let southWest = CLLocationCoordinate2DMake(centerCoordinate.latitude - 0.001, centerCoordinate.longitude - 0.001)
//        let viewport = GMSCoordinateBounds( coordinate: northEast, coordinate: southWest)
//        let config = GMSPlacePickerConfig(viewport: viewport)
//        let placePicker = GMSPlacePicker(config: config)
//        
//        placePicker?.pickPlaceWithCallback{ (place: GMSPlace?, error) in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)", terminator: "\n")
//                return
//            }
//            if let place = place {
//                print("Place name \(place.name)")
//                print("Place address \(place.formattedAddress)")
//                print("Place attributions \(place.attributions)")
//            } else {
//                print("No place selected")
//            }
//        }
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

    @IBAction func discSwitchAction(sender: UISwitch) {
        haveDisc = sender.on
//        print("haveDisc \(haveDisc)")
    }
    
    // MARK: Sign in notification
    let center = NSNotificationCenter.defaultCenter()
    
    func handleNotification() {
        let queue  = NSOperationQueue.mainQueue()
        center.addObserverForName(Constants.Notification.Name, object: nil, queue: queue)
            { notification in
            print("Recieve notification from sign in view controller", terminator: "\n")
            if let isLoginNote = notification.userInfo?[Constants.Notification.Key] as? Bool {
                print("\(isLoginNote). Temperarially disabled the notatification")
//                self.isLogin = isLoginNote
            }
        }
    }

    
    // MARK: Let master view comes at first screen
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}




 