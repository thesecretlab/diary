//
//  DYNote.h
//  Diary
//
//  Created by Jon Manning on 3/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;
@import CoreLocation;

// By making the object an NSManagedObject, it will know how to exist in a database.
@interface DYNote : NSManagedObject

/// The text stored in the note.
// 'nonatomic' means that the setter isn't guaranteed to be thread-safe.
@property (nonatomic, strong) NSString* text;

/// The date and time that the note was created.
@property (readonly) NSDate* createdDate;

/// The date and time that the note was last modified.
@property (readonly) NSDate* modifiedDate;

/// The location of the note.
@property (nonatomic, strong) CLLocation* location;

/// Returns the number of words in the note.
- (int) wordCount;

@end
