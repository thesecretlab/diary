//
//  DYNote.m
//  Diary
//
//  Created by Jon Manning on 3/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYNote.h"

// By re-declaring these properties as read-write, this class can assign values to the properties
// while still keeping everyone else from being able to do so.
@interface DYNote ()

@property (readwrite) NSDate* createdDate;
@property (readwrite) NSDate* modifiedDate;

@end

@implementation DYNote

// '@dynamic' tells the compiler to not create variables for these properties - instead,
// this storage will be handled by Core Data.
@dynamic text;
@dynamic createdDate;
@dynamic modifiedDate;
@dynamic location;
@dynamic audioNote;

- (void)awakeFromInsert {
    // Because these properties are readwrite, they can be assigned to.
        
    // Created date is now
    self.createdDate = [NSDate date];
    
    // Last modified date is also now
    self.modifiedDate = [NSDate date];
    
}

// Called when the object is about to be saved.
-(void)willSave {
    
    // When we're saved, update the last modified date.
    
    // If the last modified date is more than 1 second ago, update it.
    // (This prevents 'willSave' from infinitely recursing, because setting
    // a property makes Core Data attempt to save the object again.)
    NSDate* now = [NSDate date];
    
    if ([now timeIntervalSinceDate:self.modifiedDate] > 1.0) {
        self.modifiedDate = now;
    }
}

// The word count method splits the text up by spaces, and counts the number of pieces.
- (int) wordCount {
    
    NSArray* words = [self.text componentsSeparatedByString:@" "];
    
    return [words count];
}


@end
