//
//  DYNote.m
//  Diary
//
//  Created by Jon Manning on 3/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYNote.h"

@implementation DYNote

// The init method is called when the object is created.
- (id)init
{
    self = [super init];
    if (self) {
        
        // Set the dates. These are declared as 'readonly' in the header, so doing this won't work:
        // self.createdDate = ...
        // Instead, we set the variable directly:
        // _createdDate = ...
        
        // Created date is now
        _createdDate = [NSDate date];
        
        // Last modified date is also now
        _modifiedDate = [NSDate date];
        
    }
    return self;
}

// The word count method splits the text up by spaces, and counts the number of pieces.
- (int) wordCount {
    
    NSArray* words = [self.text componentsSeparatedByString:@" "];
    
    return [words count];
}

// Override the 'setText:' method, which is called when the 'text' property is set.
// We're overriding it because we want the 'last modified' date to be updated whenever the property is updated.
- (void)setText:(NSString *)text {
    _text = text;
    _modifiedDate = [NSDate date];
}

@end
