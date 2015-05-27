//
//  AppDelegate.m
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 10/30/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Instantiate a static dictionary object and initialize it with the content of the LocationData.plist
    // file, which resides on a server computer requiring network connection to access it.
    
    self.vtPlaceNameDict = [[NSDictionary alloc] initWithContentsOfURL:
                            [NSURL URLWithString:@"http://manta.cs.vt.edu/VTQuest/LocationData.plist"]];
    
    /*
     If the returned object reference of the newly created dictionary is nil, then the file on the server
     computer was not accessed due to a problem, which may be (1) the iOS device has no network
     connection, (2) the file is misplaced, or (3) the server is down.
     */
    
    if (self.vtPlaceNameDict == nil) {
        
        // File was not accessed. Create and display an error message.
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"File cannot be Accessed!"
                                                               message:@"Possible causes: (a) No network connection, (b) Accessed file is misplaced, or (c) Server computer is down."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
        
        [alertMessage show];
        
        // Return NO since the application was unable to access the network file.
        return NO;
    }
    
    // Obtain a sorted array of keys, i.e., VT place (building or facility) names, in ascending order.
    self.vtPlaceNames  = [[self.vtPlaceNameDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Return YES since the application was able to access the network file.
    return YES;
}

@end