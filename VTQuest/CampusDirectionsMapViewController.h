//
//  CampusDirectionsMapViewController.h
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusDirectionsMapViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

// These properties are set by the previous view controller
@property (strong, nonatomic) NSString *googleMapQuery;
@property (strong, nonatomic) NSString *directionsType;

@end