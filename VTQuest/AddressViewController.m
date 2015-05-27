//
//  AddressViewController.m
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressMapViewController.h"

@interface AddressViewController ()

@property (strong, nonatomic) NSString *mapsHtmlAbsoluteFilePath;
@property (strong, nonatomic) NSString *googleMapQuery;
@property (strong, nonatomic) NSString *adressEnteredToShowOnMap;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AddressViewController


- (void)viewDidLoad
{
    // Obtain the relative file path to the maps.html file in the main bundle
    NSURL *mapsHtmlRelativeFilePath = [[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"html"];
    
    // Obtain the absolute file path to the maps.html file in the main bundle
    self.mapsHtmlAbsoluteFilePath = [mapsHtmlRelativeFilePath absoluteString];
    
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    
    // Deselect the earlier selected map type
    [self.mapTypeSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}


- (IBAction)keyboardDone:(UITextField *)sender {
    
    // Deactivate the UITextField object and remove the Keyboard
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouch:(UIControl *)sender {
    
    // Deactivate the UITextField object and remove the Keyboard
    [self.addressTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)showAddressOnMap:(UIButton *)sender {
    
    self.adressEnteredToShowOnMap = self.addressTextField.text;
    
    // If no address is entered, alert the user
    if ([self.adressEnteredToShowOnMap isEqualToString:@""]) {
        
        // Create and display an error message
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                               message:@"Please enter an address to show on map!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
        
        [alertMessage show];
        return;
    }
    
    
    // Replace all occurrences of space in the address with +
    NSString *addressToShowOnMap = [self.adressEnteredToShowOnMap stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    switch ([self.mapTypeSegmentedControl selectedSegmentIndex]) {
            
        case 0:   // Roadmap map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=ROADMAP&zoom=16", addressToShowOnMap];
            break;
            
        case 1:   // Satellite map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=SATELLITE&zoom=16", addressToShowOnMap];
            break;
            
        case 2:   // Hybrid map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=HYBRID&zoom=16", addressToShowOnMap];
            break;
            
        case 3:   // Terrain map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=TERRAIN&zoom=16", addressToShowOnMap];
            break;
            
        default:
        {
            // Create and display an error message
            UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                                   message:@"Please select a map type!"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Okay"
                                                         otherButtonTitles:nil];
            
            [alertMessage show];
            return;
        }
    }
    
    // Perform the segue named Address
    [self performSegueWithIdentifier:@"Address" sender:self];
}


// This method is invoked when the user taps the "Show my Current Location on Map" button
- (IBAction)showCurrentLocationOnMap:(UIButton *)sender {
    
    /*
     IMPORTANT NOTE: Current GPS location cannot be determined under the iOS Simulator
     on your laptop or desktop computer because those computers do NOT have a GPS antenna.
     Therefore, do NOT expect the code herein to work under the iOS Simulator!
     
     You must deploy your location-aware app to an iOS device to be able to test it properly.
     
     To develop a location-aware app:
     
     (1) Link to CoreLocation.framework in your Xcode project
     (2) Include #import <CoreLocation/CoreLocation.h> to use its classes.
     (3) Study documentation on CLLocation, CLLocationManager, and CLLocationManagerDelegate
     */
    
    /*
     The user can turn off location services on an iOS device in Settings.
     First, you must check to see of it is turned off or not.
     */
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        
        // Create the Alert View
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                        message:@"Turn Location Services On in your device settings to be able to use location services."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        
        // Display the Alert View
        [alert show];
        
        return;
    }
    
    // Instantiate a CLLocationManager object and store its object reference
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Set the current view controller to be the delegate of the location manager object
    self.locationManager.delegate = self;
    
    // Set the location manager's distance filter to kCLDistanceFilterNone implying that
    // a location update will be sent regardless of movement of the device
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    // Set the location manager's desired accuracy within ten meters of the desired target
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Start the generation of updates that report the user’s current location.
    // Implement the protocol method below to receive and process the location info.
    
    [self.locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManager Delegate Methods

// Tells the delegate that a new location data is available
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    /*
     The objects in the given locations array are ordered with respect to their occurrence times.
     Therefore, the most recent location update is at the end of the array; hence, we access the last object.
     */
    CLLocation *currentLocation = [locations lastObject];
    
    // Obtain current location's latitude in degrees (as a double value)
    double latitudeValue = currentLocation.coordinate.latitude;
    
    // Obtain current location's longitude in degrees (as a double value)
    double longitudeValue = currentLocation.coordinate.longitude;
    
    switch ([self.mapTypeSegmentedControl selectedSegmentIndex]) {
            
        case 0:   // Roadmap map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=Current+Location&lat=%f&lng=%f&maptype=ROADMAP&zoom=16", latitudeValue, longitudeValue];
            break;
            
        case 1:   // Satellite map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=Current+Location&lat=%f&lng=%f&maptype=SATELLITE&zoom=16", latitudeValue, longitudeValue];
            break;
            
        case 2:   // Hybrid map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=Current+Location&lat=%f&lng=%f&maptype=HYBRID&zoom=16", latitudeValue, longitudeValue];
            break;
            
        case 3:   // Terrain map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=Current+Location&lat=%f&lng=%f&maptype=TERRAIN&zoom=16", latitudeValue, longitudeValue];
            break;
            
        default:
        {
            // Stops the generation of location updates since we do not need it anymore
            [manager stopUpdatingLocation];
            
            // Create and display an error message since no map type is selected
            UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                                   message:@"Please select a map type!"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Okay"
                                                         otherButtonTitles:nil];
            
            [alertMessage show];
            
            return;
        }
    }
    
    self.adressEnteredToShowOnMap = @"Current Location";
    
    // Stops the generation of location updates since we do not need it anymore
    [manager stopUpdatingLocation];
    
    // Perform the segue named Address
    [self performSegueWithIdentifier:@"Address" sender:self];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
     The kCLErrorLocationUnknown error implies that the manager is currently unable to get the location.
     We can ignore this error for the scenario of getting a single location fix, because we already
     have a timeout that will stop the location manager to save power.
     */
    if ([error code] == kCLErrorLocationUnknown) {
        
        // Create the Alert View
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Obtain Your Location"
                                                        message:@"Your location could not be determined!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        
        // Display the Alert View
        [alert show];
        
        // Stop the generation of location updates since we do not need it anymore
        [manager stopUpdatingLocation];
    }
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Address"]) {
        
        // Obtain the object reference of the destination view controller
        AddressMapViewController *addressMapViewController = [segue destinationViewController];
        
        // Pass the data object _addressToShowOnMap to the destination view controller object
        addressMapViewController.googleMapQuery = self.googleMapQuery;
        addressMapViewController.adressEnteredToShowOnMap = self.adressEnteredToShowOnMap;
    }
}

@end
