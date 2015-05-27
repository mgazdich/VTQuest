//
//  AddressViewController.h
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AddressViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;

- (IBAction)showAddressOnMap:(UIButton *)sender;
- (IBAction)showCurrentLocationOnMap:(UIButton *)sender;
- (IBAction)keyboardDone:(UITextField *)sender;
- (IBAction)backgroundTouch:(UIControl *)sender;

@end
