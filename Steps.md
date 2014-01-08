# Steps

## 00-Start

*Creating a project, understanding bundle identifiers, class prefixes. The concept of universal apps.*

1. Create a new project.
    1. Create a single-page application.
    2. Name it 'Diary'. 
    3. Set your organisation name to your name.
    4. Set the bundle identifier to your domain name, but reversed.
    3. Set the class prefix to 'DY'. 
    4. Set the device type to 'iPhone'.
    5. Ensure that 'Use Core Data' is **off**.
    
We're now going to make the app use the provided icons.

1. Open the Images.xcassets file.
2. Select the AppIcon image set.
3. In the Attributes selector, turn on 'iPad 7.0 and later sizes'.
4. Drag the appropriate images into the image slots.

*Creating new classes. View controllers. Using the interface builder. Making connections.*

We're going to make DYViewController become the DYNoteViewController.

2. Rename DYViewController to DYNoteViewController.
3. Add a text view. Make it fill the screen.
4. Select the bar at the top of the view controller, and change the Title to Note

## 01-ViewControllers

Next, we'll make the view controller that lists all of the notes.

4. Add a Navigation Controller to the storyboard.
5. Drag the Initial View Controller arrow from the Note View Controller to the Navigation Controller.
6. Drag a Table View into the Table View Controller.
7. Select the Table View. 
    1. Set its Content to Static Cells.
    2. Select the Table View Section. Set its number of rows to 1.
    3. Select the cell.
    4. Set its Style to Basic.
    
Later, we'll make it so that there's more than one cell - one for each note you add.

Now, we'll make it so that tapping the cell takes you to the Note View Controller.

8. Control-drag from the cell to the Note View Controller, and create a Push segue

One last step: set the title of the view controller.

9. Select the bar at the top of the table view controller, and change its title to Notes.

## 02-Note

*Objective-C syntax. Properties. Methods.*

1. Make a new Objective-C class named "DYNote". Make it a subclass of NSObject.

2. Add content as per DYNote.h and DYNote.m.

Key features of the Note object at this point

    @property (nonatomic, strong) NSString* text;
    @property (readonly) NSDate* createdDate;
    @property (readonly) NSDate* modifiedDate;
    - (int) wordCount;

## 03- NoteCollection

*Foundation. Arrays and other container objects. Mutable and immutable objects.*

First, we'll create the code for the Notes screen (the table view controller.)

1. Create a new Objective-C object. Call it DYNoteListViewController and make it a subclass of UITableViewController.
2. Open the Storyboard. Select the Table View Controller. Make it use DYNoteListViewController as its class.
3. Provide the code for DYNoteListViewController.m (there's nothing in the header yet.)

## 04-NoteList

*Table views. Delegates. Configuring table view cells.*

1. Open the storyboard. 
1. Change the Table View's Content from Static Cells to Dynamic Prototypes.
1. Select the table view cell.
2. Set its Identifier to NoteCell.
3. Add the `numberOfSectionsInTableView:`, `tableView: numberOfRowsInSection:` and `tableView: cellForRowAtIndexPath:` methods to DYNoteListViewController.m.

## 05-NoteEditing

*Outlets. Segues.*

First, set up DYNoteViewController by adding a property to store the note and connecting the text view to an outlet.

1. Go to the Note View Controller in the storyboard.
2. Connect the text field to the view controller - put the outlet in the class extension in DYNoteViewController.m.
3. Add a DYNote* property called 'note' in DYNoteViewController.h.
4. Implement the `viewWillAppear:` and `viewWillDisappear:` methods in DYNoteViewController.

1. Import DYNoteViewController.m in DYNoteListViewController.m.
2. Implement the `prepareForSegue:` and `viewWillAppear:` in DYNoteListViewController.

## 06-NoteAddingAndRemoval

1. Modify the `viewDidLoad` method in DYNoteListViewController to add the Edit button.
2. Implement the `tableView: commitEditingStyle: forRowAtIndexPath:` method.

Next, we'll add a + button to the top-right - when tapped, it'll add a new note.

1. Remove the code that creates the demo notes.
1. Open the storyboard.
2. Add a bar button item to the top-right of the navigation bar in the Notes List View Controller.
3. Change the new button's identifier to "Add".
4. Connect the button to an action method, called "addNote:".
5. Implement the `addNote:` method.

##07-CoreData

1. Create a new Managed Object Model. Call it "Diary".
2. Open the new model. Add a new Entity. Call it "Note".
3. Add an attribute called "text", which is a String.
4. Add two attributes: "createdDate" and "modifiedDate", both Dates.
4. Set the Class of the entity to `DYNote`.
5. Update DYNote.h and DYNote.m to reflect the latest changes. Basically, almost all of the code in these files are changed.
6. Update DYNoteListViewController.m to use DYNoteStorage.

We'll now make the table view searchable.

1. Open the storyboard.
2. Drag in a Search Bar and Search Display Controller. When you start dragging, you'll see a search bar; drag it so that it's above the table view.

Next, we'll make the view controller able to work with the search controller.

1. Open DYNoteListViewController.m 
2. Make DYNoteListViewController conform to `UISearchBarDelegate` and `UISearchDisplayDelegate`.
3. Add a new strong `NSFetchedResultsController` property called `searchFetchedResultsController`.

Next, we'll update the table view and fetched results controller delegate methods to work with the search results table.

1. Update the `numberOfSectionsInTableView:`, `tableView:numberOfRowsInSection:`, `configureCell:atIndexPath:`, `prepareForSegue:sender:`, `controllerWillChangeContent:`, `controllerDidChangeContent:`,  and `controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:` methods.

2. Implement the `searchDisplayControllerWillBeginSearch:`, `searchDisplayControllerWillEndSearch:`, `searchBar:textDidChange:` and `updateSearchQuery:` methods.

##08-UserDefaults

1. Open the storyboard. Select the Note View Controller. Change its Storyboard ID to 'NoteViewController'.
2. Update DYNoteStorage.h and .m to add the `noteWithURL:` method.
3. Update DYNoteListViewController.m's `viewDidLoad` method.
4. Update DYNoteViewController.m's `viewDidLoad` method.

##09-Location

1. Add the CoreLocation framework to the project.

Next, we'll set up the UI.

1. Open the storyboard.
2. Add a toolbar to the Note View Controller.
3. Select the bar button item that comes with the toolbar. Rename it to 'Location'.
4. Add a new view controller.
5. Set its title to 'Location'.
6. Connect the Location button the new view controller. Give it a Push segue. Name the segue 'showLocation'.
7. Add a label and an activity indicator. 
    * Make the label fill the width of the screen, and center the text.
    * Put the activity indicator beneath the label.
    * Turn on "hides when stopped".
8. Create a new view controller. Call it DYLocationViewController.
9. Set the class of the newly added screen to DYLocationViewController.

Next, we'll link up the UI to code.

1. Add outlets to DYLocationViewController's class extension:
    * Connect the label to an outlet called locationLabel.
    * Connect the activity indicator to an outlet called locationActivity.
    
Next, make the code know about DYNotes.

2. Open DYLocationViewController.h.
3. Import DYNote.h, and add a property: a DYNote called 'note'.

We now need to make notes store location info. We'll store locations as archived CLLocation objects.

1. Open Diary.xcdatamodeld.
2. Add a new attribute to the Note entity: a Transformable called 'location'.

Transformable attributes convert between objects and raw data. Any object that conforms to `NSCoding`, which is most data objects, can be stored.

3. Open DYNote.h. `@import` CoreLocation, and add a CLLocation property called 'location'.
4. Open DYNote.m, and mark the property as `@dynamic`.

Before you next re-launch the app, you'll need to erase the app and reinstall it, to prevent errors.

Next, we'll make the DYLocationViewController be given the note when the Location button is tapped.

1. Import DYLocationViewController.h in DYNoteViewController.
2. Add the `prepareForSegue:` method to DYNoteViewController.


We'll now make DYLocationViewController get the location, when it appears.

1. Open DYLocationViewController.m.
1. Make DYLocationViewController conform to CLLocationManagerDelegate.
2. Add a new property to DYLocationViewController's class extension: a CLLocationManager called locationManager.
3. Update `viewDidLoad` and implement `locationManager: didUpdateLocations:` and `locationManager: didFailWithError:` in DYLocationManager.m.

