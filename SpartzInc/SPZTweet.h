//
//  SPZTweet.h
//  SpartzInc
//
//  Created by Brad Woodard on 10/16/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPZTweet : NSObject

@property (strong, nonatomic) NSString  *screenName;
@property (strong, nonatomic) NSString  *userName;
@property (strong, nonatomic) NSString  *tweetDate;
@property (strong, nonatomic) NSString  *tweetText;
@property (strong, nonatomic) NSString  *profileImageURL;
@property (strong, nonatomic) UIImage   *profileImage;


- (instancetype)initWithTweetDictionary:(NSDictionary *)tweetDictionary;

@end
