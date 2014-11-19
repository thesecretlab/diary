//
//  DetailViewController.swift
//  Notes-iOS
//
//  Created by Jonathon Manning on 19/11/2014.
//  Copyright (c) 2014 Jonathon Manning. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
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
                
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        document?.text = textView.text
        
        document?.updateChangeCount(UIDocumentChangeKind.Done)
        
        document?.closeWithCompletionHandler() { (success) -> Void in
            
            
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

