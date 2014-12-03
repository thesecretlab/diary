//
//  LocationViewController.swift
//  Notes
//
//  Created by Jon Manning on 19/11/2014.
//  Copyright (c) 2014 Jonathon Manning. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var document : NoteDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        
        if document?.location == nil {
            
            
            locationManager.delegate = self
            
            locationManager.startUpdatingLocation()
        }
        
        updateAnnotation()
        

        // Do any additional setup after loading the view.
    }
    
    func updateAnnotation() {
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if let location = document?.location {
            
            let newAnnotation = MKPointAnnotation()
            newAnnotation.title = "Location"
            newAnnotation.coordinate = location.coordinate
            
            self.mapView.addAnnotation(newAnnotation)
        }
        
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if document?.location == nil {
            
            document?.location = locations.last as? CLLocation
            self.document?.updateChangeCount(UIDocumentChangeKind.Done)
            
            updateAnnotation()
            
            locationManager.stopUpdatingLocation()
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Error getting location: \(error)")
    }

    @IBAction func clearLocation(sender: AnyObject) {
        self.document?.location = nil
        
        self.updateAnnotation()
        
        self.document?.updateChangeCount(UIDocumentChangeKind.Done)
    }

}
