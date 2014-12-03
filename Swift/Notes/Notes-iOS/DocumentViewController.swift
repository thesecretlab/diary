//
//  DetailViewController.swift
//  Notes-iOS
//
//  Created by Jonathon Manning on 19/11/2014.
//  Copyright (c) 2014 Jonathon Manning. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController, UITextViewDelegate {

    private var document: NoteDocument?

    @IBOutlet weak var textView: UITextView!
    
    
    var documentURL : NSURL? {
        didSet {
            
            self.document = NoteDocument(fileURL: documentURL!)
            
            self.document?.openWithCompletionHandler() { (success) -> Void in
                
                self.configureView()
                
                self.userActivity = self.document?.userActivity
                
                self.documentStateUpdatedObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIDocumentStateChangedNotification, object: self.document!, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
                    
                    if let document = self.document {
                        if document.documentState & UIDocumentState.EditingDisabled != nil {
                            self.textView.resignFirstResponder()
                        }
                        
                        if document.documentState & UIDocumentState.InConflict != nil {
                            self.handleConflict()
                        }
                    }
                    
                    self.configureView()
                    
                }
                
            }
            
        }
    }

    func handleConflict() {
        
        if let document = self.document {
            
            // Get the collection of file versions
            NSFileVersion.removeOtherVersionsOfItemAtURL(document.fileURL, error: nil)
            
            for version in NSFileVersion.unresolvedConflictVersionsOfItemAtURL(document.fileURL) as [NSFileVersion] {
                version.resolved = true
            }
            
        }
        
    }
    
    func textViewDidChange(textView: UITextView) {
        self.document?.text = self.textView.text
        self.document?.updateChangeCount(UIDocumentChangeKind.Done)
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let document = self.document {
            if let textView = self.textView {
                
                textView.text = document.text

                self.navigationItem.title = document.fileURL.lastPathComponent.stringByDeletingPathExtension
            }
        }
    }
    
    private var keyboardWillChangeFrameObserver : AnyObject?
    
    
    @IBOutlet weak var toolbarConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(animated: Bool) {
        self.keyboardWillChangeFrameObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval
            let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            
            UIView.animateWithDuration(duration) { () -> Void in
                
                let distanceFromTop = self.view.window?.convertRect(keyboardRect, toView: self.view).origin.y
                let distanceFromBottom = self.view.bounds.height - distanceFromTop!
                
                self.toolbarConstraint.constant = distanceFromBottom
                
                self.view.layoutIfNeeded()
            }
            
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self.keyboardWillChangeFrameObserver!)
        NSNotificationCenter.defaultCenter().removeObserver(self.documentStateUpdatedObserver!)
        
        document?.text = textView.text
        
        document?.updateChangeCount(UIDocumentChangeKind.Done)
        
        document?.closeWithCompletionHandler() { (success) -> Void in
            
            
        }
        
    }
    
    private var documentStateUpdatedObserver : AnyObject?
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showImage" {
            
            (segue.destinationViewController as ImageViewController).document = self.document
            
        }
        
        if segue.identifier == "showLocation" {
            (segue.destinationViewController as LocationViewController).document = self.document
        }
        
    }

}

