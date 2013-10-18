//
//  SPZConstants.h
//  SpartzInc
//
//  Created by Brad Woodard on 10/16/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPZConstants : NSObject

// Strings
extern NSString *const PROFILE_IMAGE_NOTIFICATION;
extern NSString *const TWITTER_FEED_URL;
extern NSString *const NUMBER_OF_TWEETS;
extern NSString *const TIMELINE_TO_RETRIEVE;
extern NSString *const RETRIEVE_ENTITIES;

// bit AND / arithmetic shift for setting the color an item
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@end