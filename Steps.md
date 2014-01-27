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

Finally, we'll make the user able to delete the location.

4. Open the storyboard, and go to the Location View Controller.
5. Drag in a bar button item into the right side of the navigation bar.
6. Set its identifier to Trash.
7. Connect it to a new method called removeNote:.
8. Implement the method.

##10-Maps

1. Make the project use the MapKit framework.
2. Open the Storyboard. 
    * Delete the label.
    * Add a Map View to the Location View Controller. Make it fill the screen. Turn on Shows User Location.
    * Change the activity indicator to a Large White one, and keep it above the Map View.
    * Make the map use the view controller as its delegate.
    
We'll now connect it to the code.

3. Open DYLocationViewController.m.
4. `@import` MapKit.
3. Connect the Map View to an outlet called mapView.
4. Implement the `updateAnnotation` method, and update `locationManager: didUpdateLocations:` and `viewDidLoad`.

##11-Audio

1. Open the storyboard, and go to the Note View Controller.
2. Add a Flexible Space to the toolbar at the bottom of the screen.
3. Add a new Bar Button Item to the toolbar. Change its label to 'Audio'.
4. Add a new view controller. Connect the Audio button to the view controller with a Push segue. Name the segue 'showAudio'.
5. Set the title of the view controller to Audio.

Next, we'll create a new view controller to handle the audio-related tasks of the new screen.

1. Create a new UIViewController subclass, called `DYAudioViewController`.
2. Set the class of the 'Audio' view controller.

The buttons in this view controller will be this: a "play/record/stop" button (which changes state based on whether or not we're recording), and a delete button. The delete button will be in the corner, like in the location view; the play/record/stop button will be in the view. 

1. Open the Images.xcassets bundle.
2. Click +, and add a new Image Set.
3. Name it RecordButton, and drop the recording icons onto it.
4. Do the same for the Play and Stop buttons. (You can also drag pairs of images directly into the list of image sets to quickly create them.)
5. Open the Storyboard. Go to the Audio screen.
6. Add a button. Change its type to Custom. Resize it so that it's about 3 times as big, to increase its touch size.
7. Delete the Title text, and change the Image to RecordButton.
9. Drag a Bar Button Item into the right hand side of the navigation bar. Change its identifier to Trash.

Next, we'll connect up the code.

1. Open DYAudioViewController.m in the assistant.
2. Connect the record button to BOTH an outlet, called controlButton, and an action, called controlButtonTapped.
3. Connect the Trash button to an action called removeAudio:.

Next, we'll make the database be able to store the audio note data.

5. Open Diary.xcdatamodeld, and add a new attribute called 'audioNote'. Make it a binary data.
6. Open DYNote.h, and add a property for the new attribute.
7. Mark the new property as `@dynamic` in DYNote.m.

Next, we'll add the code.

1. `@import AVFoundation` in DYAudioViewController.m.

2. Open DYAudioViewController.h. `#import "DYNote.h"`. 
3. Add a DYNote* property to the class.
4. Add two new properties to DYAudioViewController.m:
   * `@property (strong) AVAudioPlayer* audioPlayer;` and
   * `@property (strong) AVAudioPlayer* audioRecorder;`
   
Next, we'll make the note view controller pass its note to the audio view controller.

1. Open DYNoteViewController.m
2. `#import DYAudioViewController.h`.
3. Update `prepareForSegue` to make it pass the note to the audio controller.


Implement DYAudioNoteViewController.

1. Add a `BOOL` instance variable to DYAudioNoteViewController's class extension, called `recordingAllowed`.
1. Implement the `controlButtonTapped:`, `startRecording`, `stopRecording`, `startPlaying`, `stopPlaying`, `removeAudio:`, `updateControlButton` and `viewWillDisappear` methods. Update the `viewDidLoad` method.

Next, we'll make the play/pause/stop button update when the end of the recording is reached.

1. Make DYAudioNoteViewController conform to the AVAudioPlayerDelegate protocol.
2. Add the `audioPlayerDidFinishPlaying: successfully:` method.
3. Update the `startPlaying` method to set the delegate.

## 12-EventKit

We'll now make the application notice when you're creating a note during an event that's on your calendar. If you create a note during an event, or within 15 minutes of it starting and ending, the default note text will read "Note created during (event name)".

1. Open DYNoteListViewController and modify the addNote: method to remove the line of code that sets the note's text.
2. Open DYNoteStorage.m.
3. `@import EventKit`.
4. Add a new `nonatomic` property to DYNoteStorage: an EKEventStore named EventStore.
5. Implement the `eventStore` method (which is a lazy getter for the property.)
6. Update the `createNote` method to request calendar access.
7. Implement the `prepareNoteWithCalendarEvent:` method, which queries the calendar and finds events to use.

## 13-LocalNotifications

We'll make it so that you can set a time for reminding you of a note.

1. Create a new subclass of UIViewController, called DYReminderViewController.
2. Open the Storyboard.
3. Go to the Note View Controller.
4. Drag in a Flexible Space into the toolbar at the bottom.
5. Drag in a Bar Button item, labelled "Reminder". Arrange everything so it goes Location - Reminder - Audio.
6. Drag in a new view controller.
7. Set its class to `DYReminderViewController`.
8. Create a segue from the Reminder button to the new view controller. Set the segue's identifier to 'showReminder'.
9. Set the title of the view controller's navigation bar to 'Reminder'.

Now, we'll set up the interface.

1. Drag in a Date Picker. Put it right in the middle of the Reminders screen.
2. Drag in a Switch. Put it above the Date Picker, and to the right.
3. Drag in a Label. Set the text to "Show reminder". Align it with the Switch.

Next, we'll connect the interface to code.

1. Open DYReminderViewController.h in the assistant.
2. `#import` DYNote.h.
3. Add a `DYNote` property called `note`.
4. Switch to DYReminderViewController.m.
5. Connect the switch to an outlet called `reminderSwitch`, **and** to an action called `reminderSwitchChanged`.
6. Connect the date picker to an outlet called `datePicker`.

Next, we'll make the note view controller pass the DYNote to the DYReminderViewController.

1. Open DYNoteViewController.m
2. Import DYReminderViewController.
3. Update `prepareForSegue:` to pass the note when the `showReminder` segue is happening.

Next, we'll add support for setting reminders.

1. Open DYNote.h.
2. Add a nonatomic `NSDate` property called `reminderDate`.
3. Open DYNote.m.
4. Declare the `reminderDate` property as `@dynamic`.
5. Implement the `localNotification`, `setReminderDate:` and `reminderDate` methods.

Finally, we'll write the code that gets and sets the reminder date. 

The way that this works is as follows: 

* when the view appears, if the note has a reminder, turn on the switch, update the date picker to use the reminder date, and make the date picker available. If it has no reminder, turn off the switch and disable the date picker. 
* When the switch is turned on or off, enable or disable the date picker.
* When the view is exited, if the switch is on, set the reminder date. Otherwise, clear the reminder date entirely (removing the notification.)

1. Add the `updateInterface` and `viewWillDisappear:` methods
2. Update the `viewDidLoad` and `reminderSwitchChanged:` methods.

##14-NicerTextView

Currently, the text view never dismisses the keyboard. We're going to make it so that tapping the text view dismisses the keyboard, when it's up.

1. Open the storyboard.
2. Drag a Tap Gesture Recognizer onto the text view.
3. Connect the gesture recognizer to a new method, called textViewTapped.
4. Implement the `textViewTapped:` method.

Now, we'll make it so that the text field adjusts its size to account for the keyboard. Additionally, because the text field is under the toolbar, we also want to take into account the toolbar's size.

1. Open the storyboard.
2. Connect the toolbar to a new outlet called 'toolbar'.
3. Implement the `updateTextInsetWithBottomHeight:`, `keyboardWillShow:` and `keyboardWillHide:` methods.
4. Update the `viewDidLoad`, `viewWillAppear` and `viewWillDisappear` methods.

##15-Images

We'll add the ability to take photos and put them in notes.

First, we'll need to store the photo data in notes.

1. Open Diary.xcdatamodeld.
2. Add a new Attribute to the Note entity: a Binary Data called `image`.
3. Open `DYNote.h`. Add a new `nonatomic` property: an `NSData` called `image`.
4. Open `DYNote.m`. Declare the `image` property as `@dynamic`.

Next, we'll set up the view controller that lets the user take, view and remove photos.

1. Create a new `UIViewController` subclass called `DYPhotoViewController`.
2. Open the storyboard. Go to the Note View Controller.
3. Add a Bar Button Item to the top-right of the navigation bar. Set its identifier to Camera.
4. Drag in a View Controller. Set its class to `DYPhotoViewController`.
5. Control-drag from the new Camera button to the new view controller, and create a new Push segue. Name the segue 'showPhoto'.
6. Set the title of the new view controller to 'Photo'.

Next, we'll set up the interface of this new view controller.

1. Drag in a Bar Button Item, and put it at the top-right of the navigation bar. Set its Identifier to Trash.
2. Drag in a Toolbar. Change the Title of the existing button to Take Photo. Drag a Flexible Space in and put it at the left hand side (so that the Take Photo button is placed at the right.)
3. Drag in a Label. Change its title to 'No Photo'. Change its font to System Bold 24pt, and change its color to Light Grey (it's one of the system colors.)
4. Drag in another Label. Change its title to "Tap Take Photo to take a new photo." Change its font to System 17pt, and change its color to Light Grey. Change the number of lines to 0, and resize it so that the text is on two lines of roughly equal length. Place it under the larger label.
5. Select both labels, and position them so that they're centered in the screen.
6. Drag in an Image View. Make it fill the screen. Change its mode to Aspect Fit. Make sure that the image is above the labels (check the Outline pane to be sure.)

Next, we'll make the photo view controller able to receive a note; we'll also make the photo view controller pass the note to the photo view controller.

1. Open DYPhotoViewController.h. 
2. Import DYNote.h.
3. Add a new `strong` property: a `DYNote` called `note`.
4. Open DYNoteViewController. Import DYPhotoViewController.h.
5. Modify 

Next, we'll connect up the interface to the code.

1. Open the storyboard, and go to the Photo View Controller. Open DYPhotoViewController.m in the Assistant.
2. Connect the image view to a new outlet called `imageView`.
3. Connect the Take Photo button to a new action called `takePhoto`.
4. Connect the Trash button to a new action called `deletePhoto`.

Next, we'll implement the code.

1. Make DYPhotoViewController conform to `UINavigationControllerDelegate` and `UIImagePickerControllerDelegate`.
2. Update the `viewDidLoad` method, and implement the `takePhoto:`, `deletePhoto:`, `imagePickerController:didFinishPickingMediaWithInfo:` and `imagePickerControllerDidCancel:` methods.

##16-iPad

We'll now port this entire app to the iPad.

1. Open the Project (select it at the top of the Project Navigator.)
2. Change Devices from iPhone to Universal. Xcode will ask if you want to copy the Storyboard file. Click Don't Copy.

    (Despite it promising to copy the file, clicking 'Copy' will actually just create a group called iPad.)

3. Still on the same page, switch from iPhone to iPad. Change the Main Interface from 'Main' to 'Main-iPad'.

Next, we'll create the storyboard for the iPad.

1. Create a new Storyboard file. (You'll find storyboards in the User Interface category.) Set the Device Family to iPad. Name it 'Main-iPad'.
2. Go to the Info tab, and ensure that the "Main storyboard file base name (iPad)" is set. If "Main nib file base name (iPad)" is set instead, change it to "storyboard". Weird Xcode bug, I guess?
2. Open the new storyboard.

The iPad app will work in a different way to the iPhone one. Whereas the iPhone version created a brand-new DYNoteViewController when the list is tapped, the iPad version will only ever have one. When a note is tapped, the text in the Note View Controller is replaced.

3. Drag in a Split View Controller.
4. Select the table view. Change its class to DYNoteListViewController.
5. Select the prototype cell, and change its identifier to "NoteCell". Change its style to Basic.

Weirdly, you can't drag a bar button item directly into the navigation bar. Instead, you need do it in a roundabout way.

1. Drag a Bar Button Item into the Note List View controller, *in the outline view*. Put it just under the First Responder item.
2. Make it use the Add identifier, and control-drag from it to the View Controller to connect it to the addItem: method.
3. Select the Navigation Item. Go to the Connections inspector. Connect the Right Bar Button Item outlet to the Bar Button Item.
4. Select the Navigation Item, and set the Title to 'Notes'. (Double-clicking the title won't work.)

When you launch the app, you can create new notes, and delete them. Next up: connecting tapping the notes to showing them.

In order to have a navigation bar that doesn't have an ugly gap above it on the iPad, you need to use a navigation controller. Therefore, the right-hand-side needs to have a navigation controller, inside of which is the note view controller. It's kind of an ugly hack.

1. Delete the larger view controller.
2. Drag in a Navigation Controller.
3. Control-drag from the Split View Controller to the Navigation Controller, and make it the Detail View Controller.
4. The navigation controller comes with a table view controller. Delete it.
5. Drag in a View Controller. Make it the root view of the Navigation Controller.
6. Select the new view controller, and set its class to DYNoteViewController.

Next, we need to set up the new Note View Controller to actually show content.

1. Drag a Text View into the note view controller. Make it fill the screen.
2. Drag a toolbar into the note view controller. Place it at the bottom of the screen.
3. Connect the text view to the `noteTextView` outlet, and the toolbar to the `toolbar` outlet.
4. Drag in three additional bar button items. Rename them so that they look like this:

`Location |--| Audio |--| Reminder <-------> (camera icon)`

(`|--|` = fixed space; `<--->` = flexible space.)

You can now type into the text field. Additionally, it will handle rotation correctly, too.

The toolbar needs to be kept at the bottom of the screen. Select it, click the Pin menu, and pin the left, bottom and right edges.

Next up, we need to make the app switch between notes. To do that, the DYNoteListViewController needs to be able to talk to the DYNoteViewController, and give it the updated note view when the selection changes. Additionally, we need to make DYNoteViewController respond when the note changes.

1. Open DYNoteViewController.h. Make the `note` property be `nonatomic`.
2. Open DYNoteViewController.m. Implement the `setNote:` method.

Next, we'll make the note change when a new note is tapped.

1. Control-drag from the Split View Controller to the Note List View Controller, and make the split view controller use the note list as its delegate.
2. Open DYNoteListViewController.m.
3. Make the class conform to `UISplitViewControllerDelegate`.
4. Update `viewDidLoad` to make the split view controller use this view controller as its delegate.
5. Implement the `splitViewController: willHideViewController: withBarButtonItem: forPopoverController:` method (which is empty - it just needs to exist.)
6. Implement the `noteViewController`
7. Implement the `tableView:didSelectRowAtIndexPath:` method.

Tapping on notes in the master view controller now switches between notes. Additionally, you can swipe to bring up the list of notes when in portrait mode.

Next up, we'll start adding the additional features.

1. Drag in a View Controller. 
2. Change its Size to Freeform; then, select the view inside it, and change its size to be 320 wide and 480 high.
3. Change its class to DYPhotoViewController.
4. Reconstruct the UI to match the iPhone version. You'll need to create the Navigation bar yourself - you don't get one for free, because this view isn't being presented in a Navigation Controller. Don't forget to connect the outlets and actions.
5. Control-drag from the Camera button in the Note View Controller to the new Photo View Controller. Choose the Popover segue style. Name the segue 'showPhoto' (same as the iPhone version's.)
6. Repeat the same process for the DYLocationViewController, the DYAudioNoteViewController and the DYReminderViewController. The names for the segues for each are `showLocation`, `showAudio` and `showReminder`.

##17-iPadPolish

There are a few remaining tweaks that we should add to the iPad version, before it's ready to ship:

* If there's no note selected, disable the right hand view controller.
* If the current note is deleted, the right hand view controller should act as if no note is selected.
* Tapping the Trash button in the Location view controller does nothing, because the original code used the navigation controller (and the iPad version doesn't have that.)

1. Open the storyboard. Go to the Note view controller.
2. Drag in a Label. Make it use the System Bold 24pt font. Change the text to "No Note Selected".
3. Open the Align menu, and add the Horizontal Center in Container and Vertical Center in Container constraints. Once that's done, select the lable and press Option-Command-= to re-position it in the center.
4. Open DYNoteViewController.m in the assistant. Connect the label to a new outlet called `noNoteLabel`.
5. Implement the `updateInterface` method. Update `setNote:` and `viewDidLoad` to call the new method.

Next, we'll make deleting the current note deselect the note.

1. Open DYNoteListViewController.m.
2. Update `controller: didChangeObject: atIndexPath: forChangeType: newIndexPath:` to set the note view controller's note to nil if it's currently displaying the note that was deleted.

Finally, we'll make it so that tapping the Trash button in the Location popover removes the location.

1. Open DYLocationViewController.m.
2. Update removeNote: to remove all annotations, stop the location manager, and set it to nil.

##18-LaunchImages

The last step is to provide launch images.

1. Open the Images.xcassets file.
2. Go to the LaunchImage image set. Go to the Attributes inspector, and turn on iPad Portrait and Landscape.
3. Drag the appropriate files into the slots.

Ship it.
