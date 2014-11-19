//
//  NoteDocument.swift
//  Notes
//
//  Created by Jon Manning on 19/11/2014.
//  Copyright (c) 2014 Jonathon Manning. All rights reserved.
//

import UIKit
import CoreLocation

class NoteDocument: UIDocument {
   
    var text : String = "Hello"
    var imageData : NSData?
    var location : CLLocation?
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        
        let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(contents as NSData) as NSDictionary
        
        self.text = dictionary["text"] as? String ?? ""
        self.imageData = dictionary["imageData"] as? NSData
        self.location = dictionary["location"] as? CLLocation
        
        return true
        
    }
    
    override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
        
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
    
}
