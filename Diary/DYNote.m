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
@dynamic image;

// The 'reminderDate' property is dynamic not because it's stored in the database, but rather
// because we'll be setting local notifications instead.
@dynamic reminderDate;

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

/// Finds the notification associated with this note, if any exists.
- (UILocalNotification*) localNotification {
    
    // Notes are associated with notifications using the note's URL.
    NSString* urlRepresentation = [[self.objectID URIRepresentation] absoluteString];
    
    // Go through all currently-scheduled notifications
    for (UILocalNotification* notification in [UIApplication sharedApplication].scheduledLocalNotifications) {
        
        // Get the note URL from this notification
        NSURL* notificationNote = notification.userInfo[@"note"];
        
        // If it's the same as this note's URL, then we've found the notification associated with this note
        if ([notificationNote isEqual:urlRepresentation])
            return notification;
    }
    
    // We didn't find it; return nil.
    return nil;
}

/// Schedules a reminder to go off at reminderDate; cancels any existing reminders.
- (void)setReminderDate:(NSDate *)reminderDate {
    
    // Get the existing notification, if any, and cancel it
    UILocalNotification* existingNotification = [self localNotification];
    
    if (existingNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
    
    // If the date is set to nil, don't schedule a new notification
    if (reminderDate == nil)
        return;
    
    // Create a new notification
    UILocalNotification* newNotification = [[UILocalNotification alloc] init];
    
    // Set the time when it's going to go off
    newNotification.fireDate = reminderDate;
    
    // Setting the timezone means that if the user changes time zones, the notification's fire date will be updated.
    // If you don't do this, the fire date is considered to be in GMT and won't update when the user changes time zones.
    newNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    // When the alert fires, show the text of this note.
    newNotification.alertBody = self.text;
    
    // Associate the notification with this object's identifier.
    newNotification.userInfo = @{@"note": [[self.objectID URIRepresentation] absoluteString]};
    
    // Schedule the notification.
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    
}

// Returns the date of the associated reminder, if any exists.
- (NSDate *)reminderDate {
    
    // Get the notification, and return its fire date.
    UILocalNotification* notification = [self localNotification];
    
    return notification.fireDate;
}

@end
