//
//  AppDelegate.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "AppDelegate.h"
#import "DataBaseManager.h"
#import "LeftMenuTableViewController.h"
#import <iOS-Slide-Menu/SlideNavigationController.h>
#import <MagicalRecord/MagicalRecord.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"RSSReader"];
    
    // Override point for customization after application launch.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    // Configure Left Menu View Controller
    LeftMenuTableViewController *leftMenu = (LeftMenuTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuTableViewController"];
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

@end
