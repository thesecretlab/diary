//
//  DYViewController.m
//  Diary
//
//  Created by Jon Manning on 3/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYNoteViewController.h"

@interface DYNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@end

@implementation DYNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

// Called when the view controller is about to appear.
- (void)viewWillAppear:(BOOL)animated {
    // Make the note text view use the text that's in the note.
    self.noteTextView.text = self.note.text;
}

// Called just before the view controlled is about to go away.
- (void)viewWillDisappear:(BOOL)animated {
    // Store the text that's in the note text view into the note itself.
    self.note.text = self.noteTextView.text;
    
    // Save the note.
    NSError* error = nil;
    [self.note.managedObjectContext save:&error];
    if (error != nil) {
        NSLog(@"Failed to save the note! %@", error);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
