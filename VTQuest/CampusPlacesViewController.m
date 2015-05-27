//
//  CampusPlacesViewController.m
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "CampusPlacesViewController.h"
#import "CampusPlaceInfoViewController.h"

@interface CampusPlacesViewController ()

// A changeable dictionary with Key = letter, Value = an array of place names starting with that letter
@property (strong, nonatomic) NSMutableDictionary *letterPlaceNames;

// A static array containing the letters A to Z
@property (strong, nonatomic) NSArray *lettersAtoZ;

// Changeable Array object to hold the data to pass to the downstream view controller
@property (strong, nonatomic) NSMutableArray *dataObjectToPass;

@end


@implementation CampusPlacesViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    // Obtain the object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Obtain the object reference to the vtPlaceNameDict dictionary object created in the App Delegate class
    self.vtPlaceNameDict = appDelegate.vtPlaceNameDict;
    
    // Obtain the object reference to the vtPlaceNames array object created in the App Delegate class
    self.vtPlaceNames = appDelegate.vtPlaceNames;
    
    /****************************************************************************************
     Objective: We want to identify the letters A to Z with which the VT place names start.
     Then, we list the letters as an index in the table view so that the user
     can select a letter to jump to the names starting with that letter.
     
     Create a changeable Dictionary with the following key-value pairs:
     KEY   =    Alphabet letter from A to Z
     VALUE =    Obj ref of a changeable Array to contain the VT place names that
     start with the alphabet letter
     ***************************************************************************************/
    
    // Obtain the object reference to the newly instantiated changeable Dictionary object
    self.letterPlaceNames = [[NSMutableDictionary alloc] init];
    
    // Declare local variables
    int         j;
    NSString    *campusPlaceName;
    char        letterChar;
    NSString    *currentLetter;
    
    // Instantiate a changeable Array object, initialize it with the first campus place name,
    // and store its object reference into local variable placeNamesForLetter
    NSMutableArray *placeNamesForLetter = [[NSMutableArray alloc] initWithObjects:[self.vtPlaceNames objectAtIndex:0], nil];
    
    // Instantiate a character string object containing the letter A
    // and store its object reference into the local variable previousLetter
    NSString *previousLetter = [NSString stringWithFormat:@"A"];
    
    // Store the number of VT place names into local variable noOfPlaces
    int noOfPlaces = (int)[self.vtPlaceNames count];
    
    
    for (j=1; j < noOfPlaces; j++) {
        
        // Obtain the jth VT place name
        campusPlaceName = [self.vtPlaceNames objectAtIndex:j];
        
        // Obtain the first character value of the VT place name
        letterChar = [campusPlaceName characterAtIndex:0];
        
        // Instantiate a character string object to hold the character value letterChar
        currentLetter = [NSString stringWithFormat:@"%c", letterChar];
        
        if ([currentLetter isEqualToString:previousLetter]) {
            
            [placeNamesForLetter addObject:campusPlaceName];
            
        } else {
            
            [self.letterPlaceNames setObject:placeNamesForLetter forKey:previousLetter];
            
            previousLetter = currentLetter;
            
            // Instantiate a NEW changeable Array object, initialize it with the campus place name,
            // and store its object reference into local variable placeNamesForLetter
            
            placeNamesForLetter = [[NSMutableArray alloc] initWithObjects:campusPlaceName, nil];
        }
    }
    
    [self.letterPlaceNames setObject:placeNamesForLetter forKey:previousLetter];
    
    // Obtain the letters to be used as an index to diplay for user to select one to jump to its section
    self.lettersAtoZ  = [[self.letterPlaceNames allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Create a changeable Array object to hold the data to pass to the downstream view controller
    // and store its object reference into dataObjectToPass
    self.dataObjectToPass = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}


#pragma mark - Table View Data Source Methods

// Asks the data source to return the number of sections in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.lettersAtoZ count];  // number of sections = number of letters
}


// Asks the data source to return the number of rows in a section, the number of which is given
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Identify the letter (key) for the section number given
    NSString *letter = [self.lettersAtoZ objectAtIndex:section];
    
    // Put all campus place names under the letter into a static array
    NSArray *placeNamesForLetter = [self.letterPlaceNames objectForKey:letter];
    
    // Return the number of campus place names in the array as the number of rows in the given section
    return [placeNamesForLetter count];
}


// Asks the data source to return a cell to insert in a particular table view location
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger sectionNumber = [indexPath section];  // Identify the section number
    NSUInteger rowNumber = [indexPath row];          // Identify the row number
    
    NSString *letter = [self.lettersAtoZ objectAtIndex:sectionNumber];
    
    NSArray *campusPlaceNamesForLetter = [self.letterPlaceNames objectForKey:letter];
    
    NSString *selectedPlaceName = [campusPlaceNamesForLetter objectAtIndex:rowNumber];
    
    NSDictionary *campusPlaceData = [self.vtPlaceNameDict objectForKey:selectedPlaceName];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTPlaces"];
    
    // Set table view cell (row) label text to campus place name
    cell.textLabel.text = selectedPlaceName;
    
    // Set table view cell (row) subtitle to campus place category
    // Select Subtitle from the table view cell Style menu in Storyboard for this to work
    cell.detailTextLabel.text = [campusPlaceData objectForKey:@"category"];
    
    // Place VT logo on the left of each table view cell
    cell.imageView.image = [UIImage imageNamed:@"vtLogo.png"];
    
    return cell;
}


// Asks the data source to return the section title for a given section number
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.lettersAtoZ objectAtIndex:section];
}


/*
 Asks the data source to return all of the section titles, i.e., letters from A to Z
 to display them as an index of selectable letters A to Z on the right side of the table view
 so that the user can tap on a letter to jump to that section.
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.lettersAtoZ;
}


#pragma mark - Table View Delegate Methods

// Tells the delegate (=self) that the row specified under indexPath is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger sectionNumber = [indexPath section];  // Identify the section number
    NSUInteger rowNumber = [indexPath row];          // Identify the row number
    
    NSString *letter = [self.lettersAtoZ objectAtIndex:sectionNumber];
    
    NSArray *campusPlaceNamesForLetter = [self.letterPlaceNames objectForKey:letter];
    
    NSString *selectedPlaceName = [campusPlaceNamesForLetter objectAtIndex:rowNumber];
    
    NSDictionary *campusPlaceData = [self.vtPlaceNameDict objectForKey:selectedPlaceName];
    
    [self.dataObjectToPass insertObject:[campusPlaceData objectForKey:@"abbreviation"] atIndex:0];
    [self.dataObjectToPass insertObject:[campusPlaceData objectForKey:@"category"] atIndex:1];
    [self.dataObjectToPass insertObject:[campusPlaceData objectForKey:@"description"] atIndex:2];
    [self.dataObjectToPass insertObject:[campusPlaceData objectForKey:@"image"] atIndex:3];
    [self.dataObjectToPass insertObject:[campusPlaceData objectForKey:@"location"] atIndex:4];
    [self.dataObjectToPass insertObject:selectedPlaceName atIndex:5];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Perform the segue named vtPlaceInfo
    [self performSegueWithIdentifier:@"vtPlaceInfo" sender:self];
    
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"vtPlaceInfo"]) {
        
        // Obtain the object reference of the destination view controller
        CampusPlaceInfoViewController *campusPlaceInfoViewController = [segue destinationViewController];
        
        // Pass the data object to the destination view controller object
        campusPlaceInfoViewController.dataObjectPassed = self.dataObjectToPass;
    }
}

@end