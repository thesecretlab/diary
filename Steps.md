# Steps

## 00-Start

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

## 02-

1. Make a new Objective-C class named "DYNote". Make it a subclass of NSObject.

2. Add content as per DYNote.h and DYNote.m.

Key features of the Note object at this point

    @property (nonatomic, strong) NSString* text;
    @property (readonly) NSDate* createdDate;
    @property (readonly) NSDate* modifiedDate;
    - (int) wordCount;


