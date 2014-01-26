//
//  DYPhotoViewController.m
//  Diary
//
//  Created by Jon Manning on 26/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYPhotoViewController.h"

@interface DYPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation DYPhotoViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the Take Photo button is tapped.
- (IBAction)takePhoto:(id)sender {
    
    
}

// Called when the user taps the Delete Photo button.
- (IBAction)deletePhoto:(id)sender {
    
}

@end
