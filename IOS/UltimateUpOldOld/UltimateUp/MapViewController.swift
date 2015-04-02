//
//  MapViewController.swift
//  UltimateUp
//
//  Created by Beck Pang on 2/22/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var map:MKMapView?
    
    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        // self.view.frame = frame
        // self.title = "UltimateUp"
        
        self.map = MKMapView(frame: frame)
        self.map!.delegate = self
        
        //self.view.addSubview(self.map!)
        
        adjustRegion(47.6570,aLongitude: -122.3075)
        addPoint("The Quad", aCategory: "University of Washington", aLatitude: 47.6570, aLongitude: -122.3075)
    }
    
    func adjustRegion(aLatitude:CLLocationDegrees, aLongitude: CLLocationDegrees){
        var latitude:CLLocationDegrees = aLatitude
        var longitude:CLLocationDegrees = aLongitude
        var latDelta:CLLocationDegrees = 0.004
        var longDelta:CLLocationDegrees = 0.004
        
        var aSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta,longitudeDelta: longDelta)
        var Center :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(Center, aSpan)
        
        self.map!.setRegion(region, animated: true)
    }
    
    func addPoint(aName:String, aCategory:String,aLatitude:CLLocationDegrees, aLongitude: CLLocationDegrees){
        var point:MKPointAnnotation = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2DMake(aLatitude,aLongitude);
        point.title = aName
        point.subtitle = aCategory
        
        map!.addAnnotation(point)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Purple
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
