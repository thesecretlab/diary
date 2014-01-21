//
//  DYViewController.m
//  Diary
//
//  Created by Jon Manning on 3/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYNoteViewController.h"
#import "DYLocationViewController.h"
#import "DYAudioViewController.h"
#import "DYReminderViewController.h"

@interface DYNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@end

@implementation DYNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // When the screen loads, get the URL of the object that we're showing.
    // Store it into the user defaults, so that if the app exits while we're editing this
    // note, the app will return to it.
    NSURL* noteURL = [self.note.objectID URIRepresentation];
    [[NSUserDefaults standardUserDefaults] setURL:noteURL forKey:@"current_note"];
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
    
    [[NSUserDefaults standardUserDefaults] setURL:nil forKey:@"current_note"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when a segue is about to happen.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showLocation"]) {
        
        // If this is the showLocation segue, we're moving to a DYLocationViewController.
        DYLocationViewController* locationViewController = segue.destinationViewController;
        
        // Give it the note.
        locationViewController.note = self.note;
    }
    
    if ([segue.identifier isEqualToString:@"showAudio"]) {
        
        // If this is the showAudio segue, we're moving to a DYAudioViewController.
        DYAudioViewController* audioViewController = segue.destinationViewController;
        
        // Give it the note.
        audioViewController.note = self.note;
    }
    
    if ([segue.identifier isEqualToString:@"showReminder"]) {
        
        // If this is the showReminder segue, we're moving to a DYReminderViewController.
        DYReminderViewController* reminderViewController = segue.destinationViewController;
        
        // Give it the note.
        reminderViewController.note = self.note;
    }
}

@end
