//
//  Document.swift
//  Notes
//
//  Created by Jonathon Manning on 19/11/2014.
//  Copyright (c) 2014 Jonathon Manning. All rights reserved.
//

import Cocoa
import CoreLocation
import MapKit

class Document: NSDocument {
    
    @IBOutlet var textField: NSTextView!

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var imageView: NSImageView!
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
        
        self.textField.string = self.text;
        
        if let location = self.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Location"
            
            self.mapView.addAnnotation(annotation)
        }
        
        if let imageData = self.imageData {
            
            if let image = NSImage(data: imageData) {
                self.imageView.image = image
            }
            
            
            
        }
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }
    
    var text : String = ""
    var imageData : NSData?
    var location : CLLocation?

    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
        
        self.text = self.textField.string ?? ""
        
        var dictionary : [String:AnyObject] = [
            "text": self.text
        ]
        
        if let imageData = self.imageData {
            dictionary["imageData"] = imageData
        }
        
        if let location = self.location {
            dictionary["location"] = location
        }
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        
        return data
        
    }
    
    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        
        let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSDictionary
        
        self.text = dictionary["text"] as? String ?? ""
        self.imageData = dictionary["imageData"] as? NSData
        self.location = dictionary["location"] as? CLLocation
        
        return true
        
    }


}

