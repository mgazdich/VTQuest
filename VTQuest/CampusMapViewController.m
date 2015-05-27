//
//  CampusMapViewController.m
//  VTQuest
//
//  Created by Mike_Gazdich_rMBP on 11/5/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "CampusMapViewController.h"

@interface CampusMapViewController ()

@property (strong, nonatomic) NSString *mapsHtmlAbsoluteFilePath;

@end


@implementation CampusMapViewController

- (void)viewDidLoad
{
    // Obtain the relative file path to the maps.html file in the main bundle
    NSURL *mapsHtmlRelativeFilePath = [[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"html"];
    
    // Obtain the absolute file path to the maps.html file in the main bundle
    self.mapsHtmlAbsoluteFilePath = [mapsHtmlRelativeFilePath absoluteString];
    
    // Compose the Google Map Query to display the default Roadmap type
    NSString *googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=VT+Campus&lat=37.22779979358401&lng=-80.42236804962158&maptype=ROADMAP&zoom=16"];
    
    // Ask the web view object to display the default map based on the given Google Map Query
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:googleMapQuery]]];
    
    [super viewDidLoad];   // Inform super
}


// This method is invoked when the user selects a map type to display
- (IBAction)setMapType:(UISegmentedControl *)sender
{
    NSString *googleMapQuery;
    
    switch ([sender selectedSegmentIndex]) {
            
        case 0:   // Roadmap map type selected
            googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=VT+Campus&lat=37.22779979358401&lng=-80.42236804962158&maptype=ROADMAP&zoom=16"];
            break;
            
        case 1:   // Satellite map type selected
            googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=VT+Campus&lat=37.22779979358401&lng=-80.42236804962158&maptype=SATELLITE&zoom=16"];
            break;
            
        case 2:   // Hybrid map type selected
            googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=VT+Campus&lat=37.22779979358401&lng=-80.42236804962158&maptype=HYBRID&zoom=16"];
            break;
            
        case 3:   // Terrain map type selected
            googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?n=VT+Campus&lat=37.22779979358401&lng=-80.42236804962158&maptype=TERRAIN&zoom=16"];
            break;
            
        default:
            return;
    }
    
    // Ask the web view object to display the map based on the given Google Map Query
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:googleMapQuery]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Starting to load the web page. Show the animated activity indicator in the status bar
    // to indicate to the user that the UIWebVIew object is busy loading the web page.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Finished loading the web page. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Ignore this error if the page is instantly redirected via javascript or in another way
    if([error code] == NSURLErrorCancelled) return;
    
    // An error occurred during the web page load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Create the error message in HTML as a character string object pointed to by errorString
    NSString *errorString = [NSString stringWithFormat:
                             @"<html><font size=+2 color='red'><p>An error occurred: %@<br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>",
                             error.localizedDescription];
    
    // Display the error message within the UIWebView object
    [self.webView loadHTMLString:errorString baseURL:nil];
}

@end
