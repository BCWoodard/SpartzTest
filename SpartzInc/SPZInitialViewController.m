//
//  SPZViewController.m
//  SpartzInc
//
//  Created by Brad Woodard on 10/15/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import <Social/Social.h>
#import "SPZInitialViewController.h"
#import "Reachability.h"

// TestFlight
#import "TestFlight.h"

@interface SPZInitialViewController ()
{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *viewTweetsButton;
    __weak IBOutlet UIButton *retryConnectionButton;
}
- (IBAction)viewTweets:(id)sender;
- (IBAction)retryConnection:(id)sender;

@end

@implementation SPZInitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Method block
    [self checkForInternet];
    
    // UI Elements
    [self.view setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// Set the status bar (time, battery, etc.) color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - REACHABILITY Methods
- (void)checkForInternet
{
    // Any app that uses web services or remote connectivity must check for reachability
    // I've employed the 3rd party framework from Tony Million, "Reachability"
    // 1. Define remote connection site
    // 2. Define the network status
    // 3. Swith statement for each of the possible results of connection check
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];  // 1
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus]; // 2
    
    // 3
    switch (myStatus) {
        case NotReachable:
            [self showReachabilityAlertView];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Internet"];
            NSLog(@"There's no internet connection at all.");
            break;
            
        case ReachableViaWWAN:
            [self showButtonAndSetUserDefaults];
            NSLog(@"We have a 3G connection");
            break;
            
        case ReachableViaWiFi:
            [self showButtonAndSetUserDefaults];
            NSLog(@"We have WiFi.");
            break;
            
        default:
            break;
    }
}

// If no connection, display an alertView (case NotReachable)
- (void)showReachabilityAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                                        message:@"SpartzTweet is unable to reach the Internet. Please check your device settings or try later."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [retryConnectionButton setHidden:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showButtonAndSetUserDefaults
{
    [viewTweetsButton setHidden:NO];
    [retryConnectionButton setHidden:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Internet"];
}


- (IBAction)viewTweets:(id)sender
{
    [self performSegueWithIdentifier:@"toTweetsList" sender:self];
    [TestFlight passCheckpoint:@"Segue to List"];
}

- (IBAction)retryConnection:(id)sender
{
    [self checkForInternet];
}
@end
