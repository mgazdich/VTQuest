//
//  DirectionsViewController.m
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "DirectionsViewController.h"
#import "DirectionsMapViewController.h"

@interface DirectionsViewController ()

@property (strong, nonatomic) NSString *googleMapQuery;

@property (strong, nonatomic) NSString *placeFromCoordinates;
@property (strong, nonatomic) NSString *placeToCoordinates;

@property (strong, nonatomic) NSString *directionsType;
@property (strong, nonatomic) NSString *mapsHtmlAbsoluteFilePath;

@end


@implementation DirectionsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    // Obtain the relative file path to the maps.html file in the main bundle
    NSURL *mapsHtmlRelativeFilePath = [[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"html"];
    
    // Obtain the absolute file path to the maps.html file in the main bundle
    self.mapsHtmlAbsoluteFilePath = [mapsHtmlRelativeFilePath absoluteString];
    
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    
    // Deselect the earlier selected directions type
    [self.directionsTypeSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Custom Methods

// This method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender
{
    // Deactivate the UITextField object and remove the Keyboard
    [sender resignFirstResponder];
}


// This method is invoked when the user taps anywhere on the background
- (IBAction)backgroundTouch:(UIControl *)sender {
    
    // Deactivate the UITextField objects and remove the Keyboard
    [self.fromPlaceTextField resignFirstResponder];
    [self.toPlaceTextField resignFirstResponder];
    
}


// This method is invoked when the user selects a directions type to get such directions
- (IBAction)getDirectionsFromAddressToAddress:(UISegmentedControl *)sender {
    
    // If the starting and/or destination address is not selected, alert the user
    if ([self.fromPlaceTextField.text isEqualToString:@""] || [self.toPlaceTextField.text isEqualToString:@""]) {
        
        // Deselect the earlier selected directions type
        [self.directionsTypeSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        // Create and display an error message
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                               message:@"Please enter both From and To addresses for directions!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
        
        [alertMessage show];
        return;
    }
    
    
    // Obtain a new string in which all occurrences of space in the address are replaced by +
    NSString *addressFrom = [self.fromPlaceTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *addressTo = [self.toPlaceTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    
    switch ([sender selectedSegmentIndex]) {
            
        case 0:  // Compose the Google directions query for DRIVING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=DRIVING", addressFrom, addressTo];
            self.directionsType = @"Driving";
            break;
            
        case 1:  // Compose the Google directions query for WALKING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=WALKING", addressFrom, addressTo];
            self.directionsType = @"Walking";
            break;
            
        case 2:  // Compose the Google directions query for BICYCLING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=BICYCLING", addressFrom, addressTo];
            self.directionsType = @"Bicycling";
            break;
            
        case 3:  // Compose the Google directions query for TRANSIT
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=TRANSIT", addressFrom, addressTo];
            self.directionsType = @"Transit";
            break;
            
        default:
            return;
    }
    
    // Perform the segue named CampusDirections
    [self performSegueWithIdentifier:@"Directions" sender:self];
    
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Directions"]) {
        
        // Obtain the object reference of the destination view controller
        DirectionsMapViewController *directionsMapViewController = [segue destinationViewController];
        
        // Pass the data object self.googleMapQuery to the destination view controller object
        directionsMapViewController.googleMapQuery = self.googleMapQuery;
        
        // Pass the data object self.directionsType to the destination view controller object
        directionsMapViewController.directionsType = self.directionsType;
    }
}

@end
