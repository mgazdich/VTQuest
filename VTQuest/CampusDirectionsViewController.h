//
//  CampusDirectionsViewController.h
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CampusDirectionsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) IBOutlet UILabel *setFromLabel;

@property (strong, nonatomic) IBOutlet UILabel *setToLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *directionsTypeSegmentedControl;

- (IBAction)setFromButtonTapped:(UIButton *)sender;
- (IBAction)setToButtonTapped:(UIButton *)sender;
- (IBAction)clearButtonTapped:(UIButton *)sender;

- (IBAction)getDirectionsOnCampus:(UISegmentedControl *)sender;

@end
