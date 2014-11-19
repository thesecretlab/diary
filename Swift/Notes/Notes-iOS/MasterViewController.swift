//
//  MasterViewController.swift
//  Notes-iOS
//
//  Created by Jonathon Manning on 19/11/2014.
//  Copyright (c) 2014 Jonathon Manning. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var containerURL : NSURL? = nil
    
    var discoveredURLs : [NSURL] = []
    
    var didFinishGatheringObserver : AnyObject?
    var didUpdateObserver : AnyObject?
    
    lazy var documentFileNameDateFormatter : NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm"
        return formatter
    }()
    
    lazy var documentQuery : NSMetadataQuery = {
        var query = NSMetadataQuery()
        
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        
        let filePattern = "*.note"
        query.predicate = NSPredicate(format: "%K LIKE %@", NSMetadataItemFSNameKey, filePattern)
        
        return query
    }()
    
    func checkiCloudAvailability( completion: Bool -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            
            self.containerURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)
            
            if self.containerURL == nil {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    NSLog("iCloud not available")
                    completion(false)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    NSLog("iCloud container: \(self.containerURL)")
                    completion(true)
                }
            }
            
        });
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.checkiCloudAvailability() { (available) in
            NSLog("\(available)")
        }
        
        self.didFinishGatheringObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            NSMetadataQueryDidFinishGatheringNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
                self.updateFileURLs()
                
        }
        
        self.didUpdateObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            NSMetadataQueryDidUpdateNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
                
                self.updateFileURLs()
                
        }
        
        self.documentQuery.startQuery()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func updateFileURLs() {
        
        self.discoveredURLs = []
        
        documentQuery.enumerateResultsUsingBlock { (obj, index, stop) -> Void in
            
            let metadataItem = obj as NSMetadataItem
            
            let url = metadataItem.valueForAttribute(NSMetadataItemURLKey) as NSURL
            let downloadState = metadataItem.valueForAttribute(NSMetadataUbiquitousItemDownloadingStatusKey) as? String
            
            if downloadState == NSMetadataUbiquitousItemDownloadingStatusCurrent {
                self.discoveredURLs.append(url)
            } else {
                NSFileManager.defaultManager().startDownloadingUbiquitousItemAtURL(url, error: nil)
            }
            
        }
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        
        // Create a new document name
        let documentName = "\(documentFileNameDateFormatter.stringFromDate(NSDate())).note"
        
        if let containerURL = self.containerURL {
            let documentURL = containerURL.URLByAppendingPathComponent("Documents").URLByAppendingPathComponent(documentName)
            
            let newDocument = NoteDocument(fileURL:documentURL)
            
            newDocument.saveToURL(documentURL, forSaveOperation: UIDocumentSaveOperation.ForCreating) { (success) -> Void in
                NSLog("Save succeded: \(success)")
            }
            
            
            
        }
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let URL = discoveredURLs[indexPath.row] as NSURL
                
                (segue.destinationViewController as DocumentViewController).documentURL = URL
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredURLs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = discoveredURLs[indexPath.row] as NSURL
        cell.textLabel.text = object.lastPathComponent
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        } else if editingStyle == .Insert {
        }
    }


}

