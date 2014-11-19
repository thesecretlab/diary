//
//  DYNoteStorage.h
//  Diary
//
//  Created by Jon Manning on 6/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

// Using the '@import' keyword makes Xcode load the Core Data framework.
@import CoreData;

#import "DYNote.h"

@interface DYNoteStorage : NSObject {
    
    
}

- (NSFetchedResultsController*) createFetchedResultsController;

+ (DYNoteStorage*) sharedStorage;

- (DYNote*) createNote;
- (void) deleteNote:(DYNote*)note;

- (DYNote*) noteWithURL:(NSURL*)url;

@end
