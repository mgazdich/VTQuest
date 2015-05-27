//
//  DirectionsViewController.h
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *directionsTypeSegmentedControl;

@property (strong, nonatomic) IBOutlet UITextField *fromPlaceTextField;
@property (strong, nonatomic) IBOutlet UITextField *toPlaceTextField;

// This method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender;

// This method is invoked when the user taps anywhere on the background
- (IBAction)backgroundTouch:(UIControl *)sender;

// This method is invoked when the user selects a directions type to get such directions
- (IBAction)getDirectionsFromAddressToAddress:(UISegmentedControl *)sender;

@end
