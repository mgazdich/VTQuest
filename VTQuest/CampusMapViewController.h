//
//  CampusMapViewController.h
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusMapViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

// This method is invoked when the user selects a map type to display
- (IBAction)setMapType:(UISegmentedControl *)sender;

@end
