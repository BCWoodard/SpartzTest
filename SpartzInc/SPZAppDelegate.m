//
//  SPZAppDelegate.m
//  SpartzInc
//
//  Created by Brad Woodard on 10/15/13.
//  Copyright (c) 2013 Brad Woodard. All rights reserved.
//

#import "SPZAppDelegate.h"
#import "SPZConstants.h"
#import "TestFlight.h"

@implementation SPZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // TestFlight Info
    [TestFlight takeOff:@"a8e3a505-6f58-435a-b616-7feece590514"];
    
    // NavigationBar customizations
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x333333)];
    // Back Button
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xffffff)];
    
    // CUSTOM FONTS AND EFFECTS
    NSShadow *navTitleShadow = [[NSShadow alloc] init];
    navTitleShadow.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    navTitleShadow.shadowOffset = CGSizeMake(0.0, 1.0);
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, navTitleShadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:24.0], NSFontAttributeName, nil]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
