//
//  DetailViewController.swift
//  Notes-iOS
//
//  Created by Jonathon Manning on 19/11/2014.
//  Copyright (c) 2014 Jonathon Manning. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    private var keyboardWillChangeFrameObserver : AnyObject?
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var toolbarConstraint: NSLayoutConstraint!
    
    var documentURL : NSURL? {
        didSet {
            
            document = NoteDocument(fileURL: documentURL!)
            
            document?.openWithCompletionHandler() { (success) -> Void in
                
                self.configureView()
            }
            
        }
    }

    private var document: NoteDocument?

    func configureView() {
        // Update the user interface for the detail item.
        if let document = self.document {
            if let textView = self.textView {
                
                textView.text = document.text

                self.navigationItem.title = document.fileURL.lastPathComponent.stringByDeletingPathExtension
            }
        }
    }
    
    
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
        
        document?.text = textView.text
        
        document?.updateChangeCount(UIDocumentChangeKind.Done)
        
        document?.closeWithCompletionHandler() { (success) -> Void in
            
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showImage" {
            
            (segue.destinationViewController as ImageViewController).document = self.document
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

