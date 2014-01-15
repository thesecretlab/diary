//
//  DYAudioViewController.m
//  Diary
//
//  Created by Jon Manning on 9/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYAudioViewController.h"

@import AVFoundation;

@interface DYAudioViewController () {
    BOOL recordingAllowed;
}

@property (weak, nonatomic) IBOutlet UIButton *controlButton;

@property (strong) AVAudioPlayer* audioPlayer;
@property (strong) AVAudioRecorder* audioRecorder;

@end

@implementation DYAudioViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // When the view loads, we want to indicate to the system that we will be both playing and recording audio.
    // This means that we need to have the recording system ready, by setting the audio category to 'play and record'.
    // By default, when we set this category, any playback will go through the receiver (the small speaker intended
    // to be held to the ear), if no other route is available.
    // Because this is a note-taking app which will be held in the user's hand, we want it to go out the main speaker,
    // so we set that option.
    NSError* error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    
    if (error != nil) {
        NSLog(@"Error setting audio session category to record: %@", error);
    }
    
    // Next, we need to ensure that we've got permission to access the microphone.
    // The first time this method is called after the app is installed, a dialog box will appear asking for permission.
    // When the user either accepts or denies access to the microphone, the system remembers the decision and calls
    // the block.
    // When the method is called subsequent times, the system skips the dialog and called the block immediately.
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        // Do we have permission to record audio?
        
        if (granted) {
            // Awesome.
            recordingAllowed = YES;
        } else {
            // Dang.
            recordingAllowed = NO;
        }
    }];
    
    // Finally, update the control button to indicate what the user can do.
    [self updateControlButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the user taps the main control button.
- (IBAction)controlButtonTapped:(id)sender {
    
    // The action that should be performed depends on what the app is currently doing.
    
    if (self.audioRecorder.isRecording) {
        // If the app is recording audio, it should stop.
        [self stopRecording];
        
    } else if (self.audioPlayer.isPlaying) {
        // If the app is playing audio, it should also stop.
        [self stopPlaying];
        
    } else if (self.note.audioNote == nil) {
        // If the note currently has no recording, start recording.
        [self startRecording];
        
    } else if (self.note.audioNote) {
        // If the note has a recording, play it.
        [self startPlaying];
        
    }
    
    // Finally, update the control button to make it reflect what the user can do now.
    [self updateControlButton];
}

// Called by controlButtonTapped: to begin audio recording.
- (void) startRecording {
    
    // If we're already recording, stop it.
    [self stopRecording];
    
    // Remove any existing audio data from the DYNote.
    self.note.audioNote = nil;
    
    // Create an NSURL that points at a location where the recording can temporarily be stored.
    NSString* temporaryDirectory = NSTemporaryDirectory();
    NSURL* temporaryFileURL = [[NSURL fileURLWithPath:temporaryDirectory] URLByAppendingPathComponent:@"Recording.wav"];
    
    // Create the recorder.
    NSError* error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:temporaryFileURL settings:nil error:&error];
    
    if (error != nil) {
        NSLog(@"Error starting recording! %@", error);
    }
    
    // Start recording.
    [self.audioRecorder record];
    
}

// Called by controlButtonTapped: to stop recording an audio note.
- (void) stopRecording {
    
    // If no audio recorder exists, bail out now to prevent erasing any existing audio note.
    if (self.audioRecorder == nil)
        return;
    
    // Stop the recorder.
    [self.audioRecorder stop];
    
    // The audio recording is now stored in a disk on file; load that file into memory.
    NSData* audioData = [NSData dataWithContentsOfURL:self.audioRecorder.url];
    
    // Store the loaded data into the DYNote.
    self.note.audioNote = audioData;
    
    // Save the changes.
    NSError* error = nil;
    [self.note.managedObjectContext save:&error];
    
    if (error != nil) {
        NSLog(@"Failed to save the note: %@", error);
    }
    
}

// Called by controlButtonTapped: to begin playback of the audio note.
- (void) startPlaying {
    
    // If, for some reason, we're already playing, stop playback.
    [self stopPlaying];
    
    // Create a new audio player using the data stored in the note.
    NSError* error = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.note.audioNote error:&error];
    
    if (error != nil) {
        NSLog(@"Error loading note! %@", error);
    }
    
    // Start playback.
    [self.audioPlayer play];
}

// Called by several other methods to stop audio playback.
- (void) stopPlaying {
    
    // No need to check to see if the audioPlayer is nil, since calling 'stop' will do nothing if it's nil
    [self.audioPlayer stop];
}

// Called when the user taps the 'delete' button.
- (IBAction)removeAudio:(id)sender {
    
    // We may be recording or playing audio. Stop it, in either case.
    [self.audioRecorder stop];
    [self.audioPlayer stop];
    
    // Remove the audio data from the note.
    self.note.audioNote = nil;
    
    // Save the change.
    NSError* error = nil;
    [self.note.managedObjectContext save:&error];
    
    if (error != nil) {
        NSLog(@"Failed to save the note: %@", error);
    }
    
    // Update the button to reflect what the user can now do.
    [self updateControlButton];
}

// Called by various other methods in this class to update the image displayed on the main button.
- (void) updateControlButton {
    
    // Depending on the state of the audio recorder and audio player, the name of the image
    // that we want to show will vary.
    NSString* imageName = nil;
    
    if (self.audioRecorder.isRecording || self.audioPlayer.isPlaying) {
        // If the audio is either recording or playing, the user can stop.
        imageName = @"StopButton";
        
    } else if (self.note.audioNote != nil) {
        
        // If an audio note is present, the user can play it. (They need to delete it before
        // recording another one.)
        imageName = @"PlayButton";
        
    } else {
        
        // If no audio note is present, the user can record one.
        imageName = @"RecordButton";
        
        // However, if access to the microphone isn't allowed (see viewDidLoad), disable the button
        // and make it semi-transparent (to indicate that it won't work.)
        if (recordingAllowed == NO) {
            self.controlButton.enabled = NO;
            self.controlButton.alpha = 0.5;
        } else {
            
            // If recording _is_ allowed, enable the button and make it fully opaque.
            self.controlButton.enabled = YES;
            self.controlButton.alpha = 1.0;
        }
        
    }
    
    // Now that we know the name of the image, we load it up and give it to the button.
    UIImage* image = [UIImage imageNamed:imageName];
    
    [self.controlButton setImage:image forState:UIControlStateNormal];
}

// Called when the view is about to go off-screen.
- (void)viewWillDisappear:(BOOL)animated {
    
    // We might be playing or recording audio. In either case, stop it now before we move to
    // another screen.
    [self stopPlaying];
    [self stopRecording];
}

@end
