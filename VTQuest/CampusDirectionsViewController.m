//
//  CampusDirectionsViewController.m
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "CampusDirectionsViewController.h"
#import "CampusDirectionsMapViewController.h"

@interface CampusDirectionsViewController ()

@property (strong, nonatomic) NSDictionary  *vtPlaceNameDict;
@property (strong, nonatomic) NSArray       *vtPlaceNames;
@property (strong, nonatomic) NSDictionary  *vtPlaceData;

@property (strong, nonatomic) NSString      *googleMapQuery;

@property (strong, nonatomic) NSString      *fromPlaceSelected;
@property (strong, nonatomic) NSString      *toPlaceSelected;

@property (strong, nonatomic) NSString      *placeFromCoordinates;
@property (strong, nonatomic) NSString      *placeToCoordinates;

@property (strong, nonatomic) NSString      *directionsType;
@property (strong, nonatomic) NSString      *mapsHtmlAbsoluteFilePath;

@end

static BOOL viewShownFirstTime = TRUE;


@implementation CampusDirectionsViewController

- (void)viewDidLoad
{
    // Obtain the object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Obtain the object reference to the vtPlaceNameDict dictionary object created in the App Delegate class
    self.vtPlaceNameDict = appDelegate.vtPlaceNameDict;
    
    // Obtain the object reference to the vtPlaceNames array object created in the App Delegate class
    self.vtPlaceNames = appDelegate.vtPlaceNames;
    
    // Obtain the relative file path to the maps.html file in the main bundle
    NSURL *mapsHtmlRelativeFilePath = [[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"html"];
    
    // Obtain the absolute file path to the maps.html file in the main bundle
    self.mapsHtmlAbsoluteFilePath = [mapsHtmlRelativeFilePath absoluteString];
    
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    
    // Obtain the number of the row in the middle of the VT place names list
    int numberOfRowToShow = (int)([self.vtPlaceNames count] / 2);
    
    // Show the picker view of VT place names from the middle
    [self.pickerView selectRow:numberOfRowToShow inComponent:0 animated:NO];
    
    // Deselect the earlier selected directions type
    [self.directionsTypeSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    if (viewShownFirstTime) {
        viewShownFirstTime = FALSE;
    } else {
        self.setFromLabel.text = @"";
        self.setToLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)setFromButtonTapped:(UIButton *)sender {
    
    NSInteger selectedRowNumber = [self.pickerView selectedRowInComponent:0];
    self.fromPlaceSelected = [self.vtPlaceNames objectAtIndex:selectedRowNumber];
    self.setFromLabel.text = self.fromPlaceSelected;
}


- (IBAction)setToButtonTapped:(UIButton *)sender {
    
    NSInteger selectedRowNumber = [self.pickerView selectedRowInComponent:0];
    self.toPlaceSelected = [self.vtPlaceNames objectAtIndex:selectedRowNumber];
    self.setToLabel.text = self.toPlaceSelected;
}


- (IBAction)clearButtonTapped:(UIButton *)sender {
    
    self.setFromLabel.text = @"";
    self.setToLabel.text = @"";
}


- (IBAction)getDirectionsOnCampus:(UISegmentedControl *)sender {
    
    // If the starting and/or destination campus place is not selected, alert the user
    
    if ([self.setFromLabel.text isEqualToString:@""] || [self.setToLabel.text isEqualToString:@""] ||
        [self.setFromLabel.text isEqualToString:@"Select and set place FROM"] ||
        [self.setToLabel.text isEqualToString:@"Select and set place TO"]) {
        
        // Deselect the earlier selected directions type
        [self.directionsTypeSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        // Create and display an error message
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                               message:@"Please select both From and To places for directions!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
        
        [alertMessage show];
        return;
    }
    
    // Obtain the GPS coordinates (latitude,longitude) for starting FROM campus place selected
    self.vtPlaceData = [self.vtPlaceNameDict objectForKey:self.fromPlaceSelected];
    self.placeFromCoordinates = [self.vtPlaceData objectForKey:@"location"];
    
    // Obtain the GPS coordinates (latitude,longitude) for destination TO campus place selected
    self.vtPlaceData = [self.vtPlaceNameDict objectForKey:self.toPlaceSelected];
    self.placeToCoordinates = [self.vtPlaceData objectForKey:@"location"];
    
    switch ([sender selectedSegmentIndex]) {
            
        case 0:  // Compose the Google directions query for DRIVING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=DRIVING",
                                   self.placeFromCoordinates, self.placeToCoordinates];
            self.directionsType = @"Driving";
            break;
            
        case 1:  // Compose the Google directions query for WALKING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=WALKING",
                                   self.placeFromCoordinates, self.placeToCoordinates];
            self.directionsType = @"Walking";
            break;
            
        case 2:  // Compose the Google directions query for BICYCLING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=BICYCLING",
                                   self.placeFromCoordinates, self.placeToCoordinates];
            self.directionsType = @"Bicycling";
            break;
            
        case 3:  // Compose the Google directions query for TRANSIT
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=TRANSIT",
                                   self.placeFromCoordinates, self.placeToCoordinates];
            self.directionsType = @"Transit";
            break;
            
        default:
            break;
    }
    
    // Perform the segue named CampusDirections
    [self performSegueWithIdentifier:@"CampusDirections" sender:self];
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CampusDirections"]) {
        
        // Obtain the object reference of the destination view controller
        CampusDirectionsMapViewController *campusDirectionsMapViewController = [segue destinationViewController];
        
        // Pass the data object self.googleMapQuery to the destination view controller object
        campusDirectionsMapViewController.googleMapQuery = self.googleMapQuery;
        
        // Pass the data object self.directionsType to the destination view controller object
        campusDirectionsMapViewController.directionsType = self.directionsType;
    }
}


#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.vtPlaceNames count];
}


#pragma mark - Picker Delegate Method

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [self.vtPlaceNames objectAtIndex:row];
}

@end