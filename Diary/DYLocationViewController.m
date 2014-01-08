//
//  DYLocationViewController.m
//  Diary
//
//  Created by Jon Manning on 8/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYLocationViewController.h"

@interface DYLocationViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locationActivity;

@property (strong) CLLocationManager* locationManager;

@end

@implementation DYLocationViewController

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
    
    if (self.note.location != nil) {
        // If the note already has a location, show the location in the text field.

        self.locationLabel.text = [self.note.location description];
    } else {
        
        // Otherwise, tell the user that we're looking for a location.
        self.locationLabel.text = @"Looking for location...";
        [self.locationActivity startAnimating];
    }
    
}

// Called when the view finishes appearing.
- (void)viewDidAppear:(BOOL)animated {
    
    // Create the location manager, and tell it to start looking for the location.
    // We do this in viewDidAppear because if no location hardware is available
    // (e.g. we're on the simulator, or permission is denied) then the location manager
    // will fail immediately (and we don't want that happening during the slide-in animation.)
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

// Called when the location manager works out where we are.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Get the first location that was found.
    CLLocation* location = [locations firstObject];
    
    // If the note doesn't already have a location..
    if (self.note.location == nil) {
        
        // Store it!
        self.note.location = location;
        
        // Show the location to the user
        self.locationLabel.text = [location description];
        
        // We're now done looking, so stop the activity indicator and stop the location manager.
        [self.locationActivity stopAnimating];
        [self.locationManager stopUpdatingLocation];
    }
    
}

// Called when the location manager fails to work out the user's location.
// This can be for many reasons - the GPS can't find any satellites, the user declined to give the app permission, etc.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    // Just go back to the previous view controller.    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
