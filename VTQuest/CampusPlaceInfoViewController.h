//
//  CampusPlaceInfoViewController.h
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusPlaceInfoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel      *buildingName;
@property (strong, nonatomic) IBOutlet UIImageView  *imageView;
@property (strong, nonatomic) IBOutlet UILabel      *buildingCodeName;
@property (strong, nonatomic) IBOutlet UILabel      *buildingCategoryName;
@property (strong, nonatomic) IBOutlet UITextView   *buildingDescription;

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

// This property is set by the previous view controller
@property (strong, nonatomic) NSMutableArray *dataObjectPassed;

// This method is invoked when the user taps the "Show on Map" button
- (IBAction)showOnMap:(id)sender;

@end
