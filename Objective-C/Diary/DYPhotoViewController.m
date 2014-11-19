//
//  DYPhotoViewController.m
//  Diary
//
//  Created by Jon Manning on 26/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYPhotoViewController.h"

@interface DYPhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
    
    // When the view loads, the note may already have an image.
    // Attempt to load it, and if that succeeds, show the image.
    UIImage* image =  [UIImage imageWithData:self.note.image];
    
    if (image) {
        self.imageView.image = image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the Take Photo button is tapped.
- (IBAction)takePhoto:(id)sender {
    
    // Create a new image picker, and configure it.
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    
    // If a camera is available, make the picker use it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        // If no camera is available (we could be on an early model
        // iPad, an iPod touch, or the iOS simulator), use the photo
        // library instead.
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // We want to be told about when the picker finishes picking.
    picker.delegate = self;
    
    // Present the picker to the user!
    [self presentViewController:picker animated:YES completion:nil];
    
}

// Called when the user taps the Delete Photo button.
- (IBAction)deletePhoto:(id)sender {
    
    // First, get rid of the image data, and empty the image view.
    self.note.image = nil;
    self.imageView.image = nil;
    
    // Next, save the changes.
    NSError* error = nil;
    
    [self.note.managedObjectContext save:&error];
    
    if (error != nil) {
        NSLog(@"Failed to save the note: %@", error);
    }
}

// Called when the user finishes taking a picture.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get the image from the info dictionary.
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    // Show the image to the user.
    self.imageView.image = image;
    
    // We also want to store the image in the database. We need to
    // convert the image into a format that can be stored - either
    // PNG or JPEG. In this example, we'll go with JPEG.
    // JPEG lets you choose how much to compress by, from 0 to 1;
    // numbers closer to 0 are smaller files, but numbers closer to
    // 1 are better quality. 0.8 is a decent compromise.
    NSData* imageData = UIImageJPEGRepresentation(image, 0.8);
    
    // Store the data in the note object, and save the database.
    self.note.image = imageData;
    
    NSError* error = nil;
    
    [self.note.managedObjectContext save:&error];
    
    if (error != nil) {
        NSLog(@"Failed to save the note: %@", error);
    }
    
    // Finally, we need to make the image picker go away.
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Called when the user taps the Cancel button in the image picker.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // The user cancelled, so we should just get rid of
    // the image picker.
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
