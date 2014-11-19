//
//  DYReminderViewController.m
//  Diary
//
//  Created by Jon Manning on 21/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYReminderViewController.h"

@interface DYReminderViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DYReminderViewController

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
    
    // When the view loads, check to see if we have a reminder scheduled.
    if (self.note.reminderDate) {
        
        // If we do, turn on the switch, and make the date picker show the reminder date.
        self.reminderSwitch.on = YES;
        self.datePicker.date = self.note.reminderDate;
        
    } else {
        
        // If we don't, just disable the switch.
        self.reminderSwitch.on = NO;
    }
    
    // Update whether or not the date picker can be used.
    [self updateInterface];
    
}

// Called when the view loads, and when the switch changes state.
- (void) updateInterface {
    
    if (self.reminderSwitch.on) {

        // If the switch is on, we can work with the date picker, so enable it.
        self.datePicker.enabled = YES;
        self.datePicker.alpha = 1.0;
        
    } else {
        
        // Otherwise, we can't work with the date picker, so disable it.
        self.datePicker.enabled = NO;
        self.datePicker.alpha = 0.5;

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the user taps the 'Show reminder' switch.
- (IBAction)reminderSwitchChanged:(id)sender {
    
    // The 'on' state of the button has already changed, so update the date picker
    // by calling updateInterface.
    [self updateInterface];
}

// Called when the view is about to go away.
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.reminderSwitch.on == YES) {
        
        // If the reminder switch is on, the user wants to set the reminder.
        // Set the date that's currently shown in the picker.
        
        NSDate* dateToSet = self.datePicker.date;
        
        if ([dateToSet timeIntervalSinceNow] <= 0) {
            // This date is in the past, so we can't use it as a reminder. Instead,
            // use a date that's 10 seconds in the future.
            dateToSet = [NSDate dateWithTimeIntervalSinceNow:10];
        }
        
        self.note.reminderDate = dateToSet;
    } else {
        
        // The switch is off, which means the user wants to have no reminder. Clear it by
        // setting the reminder date to nil.
        self.note.reminderDate = nil;
    }
}

@end
