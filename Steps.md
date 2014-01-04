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
