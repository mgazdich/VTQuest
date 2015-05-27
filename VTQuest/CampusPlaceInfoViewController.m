//
//  CampusPlaceInfoViewController.m
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "CampusPlaceInfoViewController.h"
#import "CampusPlaceOnMapViewController.h"


@interface CampusPlaceInfoViewController ()

@property (strong, nonatomic) NSString *googleMapQuery;

@end


@implementation CampusPlaceInfoViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.buildingCodeName.text = [self.dataObjectPassed objectAtIndex:0];
    
    self.buildingCategoryName.text = [self.dataObjectPassed objectAtIndex:1];
    
    self.buildingDescription.text = [self.dataObjectPassed objectAtIndex:2];
    
    NSString *imageURL = [self.dataObjectPassed objectAtIndex:3];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    
    UIImage *buildingImage = [UIImage imageWithData:imageData];
    
    if (buildingImage) {
        self.imageView.image = buildingImage;
    } else {
        self.imageView.image = [UIImage imageNamed:@"imageUnavailable.png"];
    }
    
    self.buildingName.text = [self.dataObjectPassed objectAtIndex:5];
    
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    // Deselect the earlier selected map type
    [self.mapTypeSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}


#pragma mark - Custom Method

// This method is invoked when the user taps the "Show on Map" button
- (IBAction)showOnMap:(UISegmentedControl *)sender
{
    NSString *placeCoordinates = [self.dataObjectPassed objectAtIndex:4];
    NSString *placeName = [self.dataObjectPassed objectAtIndex:5];
    
    // A Google map query parameter cannot have spaces. Therefore, replace each space with +
    NSString *placeNameWithNoSpaces = [placeName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    // Obtain the relative file path to the maps.html file in the main bundle
    NSURL *mapsHtmlRelativeFilePath = [[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"html"];
    
    // Obtain the absolute file path to the maps.html file in the main bundle
    NSString *mapsHtmlAbsoluteFilePath = [mapsHtmlRelativeFilePath absoluteString];
    
    // Split the place coordinates into Latitude and Longitude objects placed in an array
    NSArray *latitudeLongitude = [placeCoordinates componentsSeparatedByString:@","];
    
    switch ([sender selectedSegmentIndex]) {
            
        case 0:   // Roadmap map type selected
            self.googleMapQuery = [mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=%@&lat=%@&lng=%@&zoom=16&maptype=ROADMAP",
                                   placeNameWithNoSpaces, [latitudeLongitude objectAtIndex:0], [latitudeLongitude objectAtIndex:1]];
            break;
            
        case 1:   // Satellite map type selected
            self.googleMapQuery = [mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=%@&lat=%@&lng=%@&zoom=16&maptype=SATELLITE",
                                   placeNameWithNoSpaces, [latitudeLongitude objectAtIndex:0], [latitudeLongitude objectAtIndex:1]];
            break;
            
        case 2:   // Hybrid map type selected
            self.googleMapQuery = [mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=%@&lat=%@&lng=%@&zoom=16&maptype=HYBRID",
                                   placeNameWithNoSpaces, [latitudeLongitude objectAtIndex:0], [latitudeLongitude objectAtIndex:1]];
            break;
            
        case 3:   // Terrain map type selected
            self.googleMapQuery = [mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=%@&lat=%@&lng=%@&zoom=16&maptype=TERRAIN",
                                   placeNameWithNoSpaces, [latitudeLongitude objectAtIndex:0], [latitudeLongitude objectAtIndex:1]];
            break;
            
        default:
            return;
    }
    
    // Perform the segue named vtPlaceOnMap
    [self performSegueWithIdentifier:@"vtPlaceOnMap" sender:self];
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"vtPlaceOnMap"]) {
        
        // Obtain the object reference of the destination view controller
        CampusPlaceOnMapViewController *campusPlaceOnMapViewController = [segue destinationViewController];
        
        // Pass the data object self.googleMapQuery to the destination view controller object
        campusPlaceOnMapViewController.googleMapQuery = self.googleMapQuery;
        
        // Pass the data object self.buildingName.text to the destination view controller object
        campusPlaceOnMapViewController.selectedPlaceName = self.buildingName.text;
    }
}

@end
