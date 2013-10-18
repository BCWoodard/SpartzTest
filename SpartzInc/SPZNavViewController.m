//
//  SPZNavViewController.m
//  SpartzInc
//
//  Created by Brad Woodard on 10/16/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import "SPZNavViewController.h"

@interface SPZNavViewController ()

@end

@implementation SPZNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // I like the "chevron-only" look for navigation so remove text from the "Back" button.
    [self.navigationItem.backBarButtonItem setTitle:@""];
}

// I have a darker nav bar so set the status bar text color to light
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
