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
#import "DYPhotoViewController.h"

@interface DYNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *noNoteLabel;

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
    
    // When the view first appears, the keyboard is not up, so the toolbar will be the
    // biggest thing covering the text view.
    // So, make the text view adjust to the toolbar's height.
    [self updateTextInsetWithBottomHeight:self.toolbar.frame.size.height];
    
    // When the view loads, we may not have a note to show. Update the interface in case we don't.
    [self updateInterface];
    
}

// Called when the view controller is about to appear.
- (void)viewWillAppear:(BOOL)animated {
    // Make the note text view use the text that's in the note.
    self.noteTextView.text = self.note.text;
    
    // Register to be notified when the keyboard appears or disappears.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    
    // Hide the keyboard.
    [self.noteTextView resignFirstResponder];
    
    // Unregister to be notified about the keyboard.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        
        // If this is the showPhoto segue, we're moving to a DYPhotoViewController.
        DYPhotoViewController* photoViewController = segue.destinationViewController;
        
        // Give it the note.
        photoViewController.note = self.note;
    }
}

// Called when the user taps on the text view.
- (IBAction)textViewTapped:(id)sender {
    
    // If the text view is currently the first responder (i.e. owns the keyboard),
    // make it resign the keyboard.
    if ([self.noteTextView isFirstResponder])
        [self.noteTextView resignFirstResponder];
    
    // Otherwise, make it _become_ the first responder.
    else
        [self.noteTextView becomeFirstResponder];
}

// Called when the keyboard is about to appear.
- (void) keyboardWillShow:(NSNotification*)notification {
    
    // Get the frame (position and size) of the keyboard.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    // We only care about the keyboard's height. Make the text view account for the
    // fact that it's taking up space.
    [self updateTextInsetWithBottomHeight:keyboardFrame.size.height];
    
}

// Called when the keyboard is about to disappear.
- (void) keyboardWillHide:(NSNotification*)notification {
    
    // The keyboard's about to be gone; make the text view adjust.
    [self updateTextInsetWithBottomHeight:self.toolbar.frame.size.height];
    
}

// Called by viewDidLoad, keyboardWillShow and keyboardWillHide to adjust the
// scrolling region of the text view.
- (void) updateTextInsetWithBottomHeight:(float)height {
    
    // Get the current frame of the text view.
    CGRect textViewRect = self.view.frame;
    
    // The text view should fill the available vertical height. So, take the height of the view, subtract 'height', and use that as the frame's height.
    textViewRect.size.height = self.view.frame.size.height - height;
    
    // Finally, make the text view use the new frame.
    self.noteTextView.frame = textViewRect;
}

// Called when the view controller is given a new DYNote.
- (void)setNote:(DYNote *)note {
    
    // First, we need to store the current text into the note.
    
    // Before we try to save, ensure that the note is still valid.
    // (The underlying data may have been deleted, so check first.)
    if (self.note.isFault == NO)
        self.note.text = self.noteTextView.text;
    
    // Update to use the new DYNote.
    _note = note;
    self.noteTextView.text = self.note.text;
    
    // Dismiss the keyboard, if it's up.
    [self.noteTextView resignFirstResponder];
    
    // Update the current note URL to reflect the fact that
    // we're looking at a new note.
    NSURL* noteURL = [self.note.objectID URIRepresentation];
    [[NSUserDefaults standardUserDefaults] setURL:noteURL forKey:@"current_note"];
    
    // Update the interface so that the view is either enabled or
    // disabled (depending on whether we have a note or not
    [self updateInterface];
}

// Called by viewDidLoad and setNote: to update the interface depending on whether we have a note or not.
- (void) updateInterface {
    
    // If we have no note, make the 'no note' label visible, disable the
    // view so that no buttons can be tapped, and make everything grey.
    if (self.note == nil) {
        self.noNoteLabel.hidden = NO;
        self.view.userInteractionEnabled = NO;
        self.view.tintColor = [UIColor grayColor];
    } else {
        
        // Otherwise, if we have a note, hide the 'no note' label, enable user interaction, and return the colours to normal.
        self.noNoteLabel.hidden = YES;
        self.view.userInteractionEnabled = YES;
        self.view.tintColor = nil;
    }
}

@end
