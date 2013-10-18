//
//  SPZTweet.m
//  SpartzInc
//
//  Created by Brad Woodard on 10/16/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import "SPZTweet.h"
#import "SPZConstants.h"

@implementation SPZTweet

- (instancetype)initWithTweetDictionary:(NSDictionary *)tweetDictionary
{
    self = [super init];
    
    // Need to differentiate between tweets from SpartzInc and others
    // 1. If the object "retweeted_status" is nil, then Spartz posted
    // 2. Else a different entity posted
    if (self) {
        if (![tweetDictionary objectForKey:@"retweeted_status"]) {  // 1
            _screenName = [tweetDictionary valueForKeyPath:@"user.screen_name"];
            _userName = [tweetDictionary valueForKeyPath:@"user.name"];
            _profileImageURL = [tweetDictionary valueForKeyPath:@"user.profile_image_url_https"];
            _tweetDate = [tweetDictionary valueForKeyPath:@"created_at"];
            _tweetText = tweetDictionary[@"text"];

        } else {  // 2
            _screenName = [tweetDictionary valueForKeyPath:@"retweeted_status.user.screen_name"];
            _userName = [tweetDictionary valueForKeyPath:@"retweeted_status.user.name"];
            _profileImageURL = [tweetDictionary valueForKeyPath:@"retweeted_status.user.profile_image_url"];
            _tweetDate = [tweetDictionary valueForKeyPath:@"retweeted_status.created_at"];
            _tweetText = [tweetDictionary valueForKeyPath:@"retweeted_status.text"];
        }
        
        // Retrieve the profile image for each tweet object
        [self fetchProfileImage];
    }

    return self;
}

- (void)fetchProfileImage
{
    // In order to speed performance of the table we load profile images as they are needed
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.profileImageURL]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        _profileImage = [UIImage imageWithData:data];
        // Send notification that our download is complete
        [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_IMAGE_NOTIFICATION object:self];
    }];
}

- (UIImage *)profileImage
{
    // If the profile image already exists, use it
    if (_profileImage) {
        return _profileImage;
    }
    
    // If the profile image has not yet been downloaded, use the placeholder image
    _profileImage = [SPZTweet placeholderImage];
    return _profileImage;
}


+ (UIImage *)placeholderImage
{
    // Set the placeholder image to the icon if it isn't available from data feed
    return [UIImage imageNamed:@"icon"];
}


@end
