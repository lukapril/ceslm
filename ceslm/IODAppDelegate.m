//
//  IODAppDelegate.m
//  ceslm
//
//  Created by April Luk on 12-06-07.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODAppDelegate.h"
#import "EventType.h"
#import "IODEventTypeTableViewController.h"

@implementation IODAppDelegate {
}

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.    
    // Configure and load event Types
    
    UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"nav-background"] 
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:NavigationPortraitBackground 
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [self updateData];
        
    return YES;
}

- (void)updateData
{
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *jsonError;
    
    if (ENV == @"PROD") {
        // Attempt to download data - EventTypes.json
        NSData *eventTypejsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:EVENT_TYPES_JSON]];
        if (eventTypejsonData) {
            NSLog(@"DEBUG: loading EventTypes.json from server...");
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"EventTypes.json"];
            [eventTypejsonData writeToFile:filePath atomically:YES];
        }
        else {
            // copy file from package
            NSLog(@"DEBUG: copying EventTypes.json from app Resources directory...");
            NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"EventTypes" ofType:@"json"];
            NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];
            [jsonData writeToFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"EventTypes.json"] atomically:YES];
        }
        
        // Attempt to download data - AboutUs.html
        NSData *aboutUsHtmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ABOUT_US_URL]];
        if (aboutUsHtmlData) {
            NSLog(@"DEBUG: loading AboutUs.html from server...");
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"AboutUs.html"];
            [aboutUsHtmlData writeToFile:filePath atomically:YES];
        }
        else {
            // copy file from package
            NSLog(@"DEBUG: copying AboutUs.html from app Resources directory...");
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AboutUs" ofType:@"html"];
            NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
            [htmlData writeToFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"AboutUs.html"] atomically:YES];
        }
        
        // Attempt to download data - ChurchDetails.json
        NSData *churchDetailsjsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:CHURCH_DETAILS_JSON]];
        if (churchDetailsjsonData) {
            NSLog(@"DEBUG: loading ChurchDetails.json from server...");
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"ChurchDetails.json"];
            [churchDetailsjsonData writeToFile:filePath atomically:YES];
        }
        else {
            // copy file from package
            NSLog(@"DEBUG: copying ChurchDetails.json from app Resources directory...");
            NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"ChurchDetails" ofType:@"json"];
            NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];
            [jsonData writeToFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"ChurchDetails.json"] atomically:YES];
        }
        
        // Attempt to download data - ChurchESLCalgary.kml
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:CHURCH_ESL_CALGARY_KML]];
        if (urlData) {
            NSLog(@"DEBUG: loading ChurchESLCalgary.kml from server...");
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"ChurchESLCalgary.kml"];
            [urlData writeToFile:filePath atomically:YES];
        }
        else {
            // copy file from package
            NSLog(@"DEBUG: copying ChurchESLCalgary.kml from app Resources directory...");
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ChurchESLCalgary" ofType:@"kml"];
            NSData *kmlData = [NSData dataWithContentsOfFile:filePath];
            [kmlData writeToFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"ChurchESLCalgary.kml"] atomically:YES];
        }
    }
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
