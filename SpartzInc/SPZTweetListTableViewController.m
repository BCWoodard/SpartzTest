//
//  SPZTestTableViewController.m
//  SpartzInc
//
//  Created by Brad Woodard on 10/16/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <QuartzCore/QuartzCore.h>
#import "SPZTweetListTableViewController.h"
#import "SPZTweetDetailViewController.h"
#import "SPZTweet.h"
#import "SPZConstants.h"

#import "TestFlight.h"

@interface SPZTweetListTableViewController ()
{
    NSArray                         *tweetsArray;
    NSDateFormatter                 *dateFormatterJSON;
    NSDateFormatter                 *dateFormatterDisplay;
    NSInteger                       selectedRow;
}

@end



@implementation SPZTweetListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Alloc & init
    // 1. dateFormatterJSON - format the date retrieved from the JSON
    // 2. dateFormatterDisplay - format the date for display in the app
    dateFormatterJSON = [[NSDateFormatter alloc] init];  // 1
    dateFormatterDisplay = [[NSDateFormatter alloc] init];  // 2
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // If we have an Internet connection, query Twitter for data
    [self fetchTwitterData];
    
    // Listen for notification that profile image is downloaded
    [self listenForNotifications];
    
    // UI Elements
    // 1. Show the navigation bar
    // 2. Hide the back button (no need to go back to initialView)
    // 3. Hide text from the "Back" button on the detail view
    [self.navigationController setNavigationBarHidden:NO animated:NO];  // 1
    [self.navigationItem setHidesBackButton:YES];  // 2
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil]];  // 3


    // Refresh Control
    // 1. Alloc & init
    // 2. Style the control
    // 3. Add a target (i.e. refresh tweets)
    // 4. Assign the refreshControl to the View's refreshControl property
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];  // 1
    [refreshControl setTintColor:[UIColor darkGrayColor]];  // 2
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Pull to refresh…"]];
    [refreshControl addTarget:self action:@selector(refreshTwitterFeed) forControlEvents:UIControlEventValueChanged];  // 3
    self.refreshControl = refreshControl;  // 4

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tweetsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SPZTweet *displayTweet = [tweetsArray objectAtIndex:indexPath.row];
    
    // Cell text fields
    cell.textLabel.text = displayTweet.tweetText;
    cell.detailTextLabel.text = [self formatDateFromTweetObject:displayTweet];
    
    // Format profile image
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 5.0f;
    cell.imageView.image = displayTweet.profileImage;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. Set the value for selectedRow
    // 2. Perform segue to detail view
    // 3. Added a TestFlight Checkpoint
    selectedRow = indexPath.row;  // 1
    [self performSegueWithIdentifier:@"toTweetDetail" sender:self];  // 2
    [TestFlight passCheckpoint:@"Segue to Detail View"];  // 3
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 1. Connect to the detailView
    // 2. Assign the tweet object to the incomingTweet property of the detailView
    SPZTweetDetailViewController *tweetDetailView = segue.destinationViewController;  // 1
    tweetDetailView.incomingTweet = [tweetsArray objectAtIndex:selectedRow];  // 2
}


#pragma mark - Fetch Twitter Data
- (void)fetchTwitterData
{
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Internet"]) {
//        return;
//    }
    
    // Create an account object of type ACAccountStore
    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    // Look for Twitter accounts created on the device
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         // Start activity indicator
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
         
         // If we have access to the Twitter accounts configured on the device we can continue
         if (granted == YES) {
             
             // Retrieve the Twitter accounts on the device and add to arrayOfAccounts
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             
             // If there is a least one account we will contact the Twitter API.
             if ([arrayOfAccounts count] > 0) {
                 // Select the last account in the arrayOfAccounts to be the access account for Twitter
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 // API call that returns entries from Twitter (defined in SPZConstants)
                 NSURL *requestAPI = [NSURL URLWithString:TWITTER_FEED_URL];
                 
                 // Send parameters to the requestAPI
                 // 1. The requestAPI requires parameters so it knows what to return so we use a NSDictionary
                 // 2. How many results to return
                 // 3. What screen name to retrieve result for
                 // 4. Set the Boolean for including entities
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];  // 1
                 [parameters setObject:NUMBER_OF_TWEETS forKey:@"count"];  // 2
                 [parameters setObject:TIMELINE_TO_RETRIEVE forKey:@"screen_name"];  // 3
                 [parameters setObject:RETRIEVE_ENTITIES forKey:@"include_entities"];  // 4
                 
                 // Retrieve the posts from Twitter
                 // 1. Use the requestAPI and defined parameters
                 // 2. Assign the twitterAccount value to the posts property "account"
                 SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters];  // 1
                 posts.account = twitterAccount;  // 2
                 
                     
                 // The performRequestWithHandler: method call now accesses the NSData object returned.
                 [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      // Use NSJSONSerialization to parse the tweet data and populate our array
                      NSArray *tweetsDataArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                      
                      // Populate our tweetsArray
                      // 1. Create a temporary array to store our SPZTweet objects (protects our tweetsArray from accidental changes as we use it later)
                      // 2. Enumerate thru our tempArray
                      // 3. Create SPZTweet objects
                      // 4. Add SPZTweet object to tempArray
                      NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[NUMBER_OF_TWEETS integerValue]];  // 1
                      for (NSDictionary *tweetDictionary in tweetsDataArray) {  // 2
                          SPZTweet *tweet = [[SPZTweet alloc] initWithTweetDictionary:tweetDictionary];  // 3
                          [tempArray addObject:tweet];  // 4
                      }
                      
                      // Alloc and initialize tweetsArray with tempArray
                      tweetsArray = [[NSArray alloc] initWithArray:tempArray];
                      
                      // If we have data in our tweetsArray, reload the tableView
                      if (tweetsArray.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tableView reloadData];
                          });
                      }
                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                  }];
             }
         } else {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}


#pragma mark - Supporting Methods
- (NSString *)formatDateFromTweetObject:(SPZTweet *)theTweet
{
    NSString *formattedDate = [[NSString alloc] init];
    
    // Format the date for presentation in the app
    // 1. Map the date format from the data feed
    // 2. Create a date object from the data string
    // 3. Convert that date into a string for display
    [dateFormatterJSON setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];  // 1
    NSDate *tweetDate = [dateFormatterJSON dateFromString:theTweet.tweetDate];  // 2
    [dateFormatterDisplay setDateFormat:@"MMMM dd, yyyy"];  // 3
    
    formattedDate = [dateFormatterDisplay stringFromDate:tweetDate];
    
    return formattedDate;
    
}

- (void)refreshTwitterFeed
{
    [self fetchTwitterData];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [TestFlight passCheckpoint:@"Pulled to Refresh"];
}


- (void)listenForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getProfileImage:)
                                                 name:PROFILE_IMAGE_NOTIFICATION
                                               object:nil];
}


- (void)getProfileImage:(NSNotification *)note
{
    // Load the image in the table once it is downloaded
    // 1. Create an instance of a tweet object
    // 2. Get the index of that tweet object from our array
    // 3. Need an indexPath since reloadRowsAtIndexPaths: takes an array as its argument
    // 4. Reload the row and display the new image
    SPZTweet *tweet = note.object;  // 1
    NSUInteger tweetIndex = [tweetsArray indexOfObject:tweet];  // 2
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tweetIndex inSection:0];  // 3
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];  // 4
}

@end
