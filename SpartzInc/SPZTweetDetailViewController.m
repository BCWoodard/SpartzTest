//
//  SPZTweetDetailViewController.m
//  SpartzInc
//
//  Created by Brad Woodard on 10/16/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import "SPZTweetDetailViewController.h"
#import "SPZConstants.h"

@interface SPZTweetDetailViewController ()
{
    __weak IBOutlet UIImageView     *profileImageView;
    __weak IBOutlet UILabel         *profileNameLabel;
    __weak IBOutlet UILabel         *profileUsernameLabel;
    __weak IBOutlet UILabel         *tweetDateLabel;
    __weak IBOutlet UILabel         *tweetLabel;
    
}

@end

@implementation SPZTweetDetailViewController
@synthesize incomingTweet;

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
    
    // Set title in nav bar
    [self.navigationItem setTitle:[NSString stringWithFormat:@"@%@", incomingTweet.screenName]];
    
    // View background color (Spartz yellow)
    [self.view setBackgroundColor:UIColorFromRGB(0xb0de41)];
    
    // Tweet fields
    profileImageView.image = incomingTweet.profileImage;
    profileNameLabel.text = incomingTweet.userName;
    profileUsernameLabel.text = [NSString stringWithFormat:@"@%@", incomingTweet.screenName];
    
    // Format the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *tweetDate = [dateFormatter dateFromString:incomingTweet.tweetDate];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    tweetDateLabel.text = [dateFormatter stringFromDate:tweetDate];
    tweetLabel.text = incomingTweet.tweetText;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
