//
//  DYNoteListViewController.m
//  Diary
//
//  Created by Jon Manning on 3/01/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "DYNoteListViewController.h"
#import "DYNote.h"
#import "DYNoteViewController.h"
#import "DYNoteStorage.h"

// This is a 'class extension', which lets you add methods, properties and variables
// to a class without having to put them in the header file, which other classes can see.
// Anything you put in the class extension can only be accessed by this class.

// By adding <NSFetchedResultsControllerDelegate> after the parentheses,
// we're telling the compiler that this object can work as a delegate for
// an NSFetchedResultsController.
@interface DYNoteListViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
}

// The fetched results controller is the way we get info about the notes in the database.
@property (strong) NSFetchedResultsController* fetchedResultsController;

// The search fetched results controller is the way we get search results from the database
@property (strong) NSFetchedResultsController* searchFetchedResultsController;

@end

@implementation DYNoteListViewController

- (void)viewDidLoad {
    
    // Get the table view's "Edit" button, which will put the table into Edit mode when tapped
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Get the note storage system to give us a fetched results controller, which we can use
    // to get the notes themselves.
    self.fetchedResultsController = [[DYNoteStorage sharedStorage] createFetchedResultsController];
    
    // Tell the fetched results controller to let us know when data changes.
    self.fetchedResultsController.delegate = self;
    
    // Finally, tell the controller to start getting objects, and watching for changes.
    NSError* error = nil;
    [self.fetchedResultsController performFetch:&error];

    if (error != nil) {
        NSLog(@"Problem fetching results! %@", error);
    }
    
}

// Returns the number of sections (groups of cells) in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Ask the fetched results controller to tell us how many sections there are.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [[self.searchFetchedResultsController sections] count];
    } else {
        return [[self.fetchedResultsController sections] count];
    }
}


// Returns the number of rows (cells) in the given section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Ask the fetched results controller to tell us about how many rows are in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.searchFetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
}

// Returns a table view cell for use, which shows the data we want to display.
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get a cell to use.
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"NoteCell"];
    
    [self configureCell:cell atIndexPath:indexPath inTableView:tableView];
    
    // Return the cell to the table view, which will then show it.
    return cell;
    
}

// Called by either tableView:cellForRowAtIndexPath: or by
// controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:.
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView*) tableView {
    
    // Work out which note should be shown in this cell.
    
    DYNote* note = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        note = [self.searchFetchedResultsController objectAtIndexPath:indexPath];
    } else {
        note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    // Give the note's text to the cell.
    cell.textLabel.text = note.text;
}

// Called when the view controller is about to move to another view controller.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // If this is the "showNote" segue, then we're about to segue to the Note View Controller because the user tapped on a table view cell.
    if ([segue.identifier isEqualToString:@"showNote"]) {
        
        // Get the note view controller we're about to move to.
        DYNoteViewController* noteViewController = segue.destinationViewController;
        
        // Get the cell that was tapped on.
        UITableViewCell* cell = sender;
        
        // Work out which row this cell was.
        NSIndexPath* indexPath = nil;
        
        DYNote* note = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
            note = [self.searchFetchedResultsController objectAtIndexPath:indexPath];
        } else {
            indexPath = [self.tableView indexPathForCell:cell];
            note = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        
        noteViewController.note = note;
    }
}

// Called when the user has tapped the Delete button.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // We only want to take action if the edit that was made is a deletion.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Find the note that we're talking about
        DYNote* note = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (note != nil)
            [[DYNoteStorage sharedStorage] deleteNote:note];
        
    }
}

// Called when the fetched results controller is about to start reporting changes.
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // Tell the table view to prepare to group together a bunch of animations.
    
    if (controller == self.searchFetchedResultsController) {
        [self.searchDisplayController.searchResultsTableView beginUpdates];
    } else {
        [self.tableView beginUpdates];
    }
    
}

// Called when the fetched results controller has finished reporting changes.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    // Tell the table view that we're done doing updates, so it can perform the animations
    // that have been queued up.
    
    if (controller == self.searchFetchedResultsController) {
        [self.searchDisplayController.searchResultsTableView endUpdates];
    } else {
        [self.tableView endUpdates];
    }
    
    
}

// Called when the fetched results controller has a change to report.
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView* tableView = nil;
    if (controller == self.searchFetchedResultsController) {
        tableView = self.searchDisplayController.searchResultsTableView;
    } else {
        tableView = self.tableView;
    }
    
    // Different changes need different animations:
    switch (type) {
        case NSFetchedResultsChangeInsert:
            // A new object was inserted, so tell the table view to animate a new cell in.
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            // An object was deleted, so tell the table view to delete the appropriate row.
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeUpdate:
            // An object was changed, so update its contents by calling configureCell:atIndexPath.
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath inTableView:tableView];
            break;
            
        case NSFetchedResultsChangeMove:
            // An object was move, so delete the row that it used to be in, and insert one where it's now located.
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

// Called when the user taps the Add button.
- (IBAction)addNote:(id)sender {
    
    // Tell the DYNoteStorage to create a new note.
    DYNote* newNote = [[DYNoteStorage sharedStorage] createNote];
    newNote.text = @"New Note";
    
}

// Called when search begins (when the user taps in the search box)
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searchFetchedResultsController = [[DYNoteStorage sharedStorage] createFetchedResultsController];
    self.searchFetchedResultsController.delegate = self;
    
    [self updateSearchQuery:self.searchDisplayController.searchBar.text];
}

// Called when search ends (when the user taps the 'Cancel' button)
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searchFetchedResultsController = nil;
}

// Called when the search text changes.
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateSearchQuery:searchText];
}

// Called by searchBar:textDidChange: and searchDisplayControllerWillBeginSearch: to update
// the search request.
- (void) updateSearchQuery:(NSString*)searchQuery {
    
    // Get the existing fetch request.
    NSFetchRequest* fetchRequest = self.searchFetchedResultsController.fetchRequest;
    
    if ([searchQuery length] > 0) {
        
        // If the search text is not empty, create a predicate (aka a search query) that
        // does a case-insensitive search for the searchQuery text in the 'text' attribute.
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"text contains[c] %@", searchQuery];
        
        // Give the new predicate to the fetch request.
        fetchRequest.predicate = predicate;
    }
    
    // Now that the fetch request is updated, make the fetched results controller
    // use the new fetch request. (This will cause the search results to update.)
    NSError* error = nil;
    
    [self.searchFetchedResultsController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Error fetching search results: %@", error);
    }
    
}

@end
