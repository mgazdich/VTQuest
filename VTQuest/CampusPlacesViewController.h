//
//  CampusPlacesViewController.h
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CampusPlacesViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *vtPlaceNameDict;
@property (strong, nonatomic) NSArray *vtPlaceNames;

@end