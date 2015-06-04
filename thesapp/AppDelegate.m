//
//  AppDelegate.m
//  ThesApp
//
//  Created by Paolo Burzacca on 28/04/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "AppDelegate.h"
#import "ScrollerViewController.h"
#import "SideMenuTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //IOS 7
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
    [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
    
    // iOS 8:
    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor blueColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    UIStoryboard * st =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString *ScrollerViewControllerID = @"mainNavID";
    NSString *SideMenuTableViewControllerID = @"SideMenuTableViewControllerSID";
    
    UINavigationController *svc = (UINavigationController *) [st instantiateViewControllerWithIdentifier:ScrollerViewControllerID];
    
    NSLog(@"svc = %@", [svc description]);
    
    SideMenuTableViewController *side = (SideMenuTableViewController *) [st instantiateViewControllerWithIdentifier:SideMenuTableViewControllerID];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:svc
                                             leftDrawerViewController:nil
                                             rightDrawerViewController:side];

    //drawerController.view.clipsToBounds = YES;
    
    float menuWidth = [UIScreen mainScreen].applicationFrame.size.width - 50;
    
    [drawerController setMaximumRightDrawerWidth:menuWidth];
    
    [drawerController setShowsShadow:NO];
    
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    self.window.rootViewController = drawerController;
    
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
