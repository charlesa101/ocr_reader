//
//  SnapReceiptAppDelegate.m
//  SnapReceipt
//
//  Created by Charles Adetiloye on 2/10/11.
//  Copyright 2011 MavenCode. All rights reserved.
//

#import "SnapReceiptAppDelegate.h"
#import "CameraViewController.h"
#import "ReportViewController.h"
#import "ReceiptListViewController.h"
#import "settingsViewController.h"


@interface SnapReceiptAppDelegate(PrivateMethod)

-(void) buildUIlayout;

@end


@implementation SnapReceiptAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize cameraViewController, reportViewController, receiptListViewController, settingsViewController;


#pragma mark -
#pragma mark Do layout setup

-(void) buildUIlayout
{
	tabBarController = [[UITabBarController alloc] init];
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:4];	
	
	UINavigationController	*navigationController = nil;
	
	cameraViewController = [[CameraViewController alloc] init];
	cameraViewController.title = @"Snap Receipt!";
	cameraViewController.tabBarItem.title = @"Snap Receipt!";
	cameraViewController.navigationItem.title = @"Snap Receipt!";
	navigationController = [[UINavigationController alloc] initWithRootViewController:cameraViewController];
	[viewControllers addObject:navigationController]; 
	[navigationController release];
	
	receiptListViewController = [[ReportViewController alloc] init];
	receiptListViewController.title = @"My Receipts";
	receiptListViewController.tabBarItem.title = @"My Receipts";
	receiptListViewController.navigationItem.title = @"My Receipts";
	navigationController = [[UINavigationController alloc] initWithRootViewController:receiptListViewController];
	[viewControllers addObject:navigationController]; 
	[navigationController release];
	
	reportViewController = [[ReportViewController alloc] init];
	reportViewController.title = @"Report";
	reportViewController.tabBarItem.title = @"Report";
	reportViewController.navigationItem.title = @"Report";
	navigationController = [[UINavigationController alloc] initWithRootViewController:reportViewController];
	[viewControllers addObject:navigationController]; 
	[navigationController release];
	
	settingsViewController = [[SettingsViewController alloc] init];
	settingsViewController.title = @"Settings";
	settingsViewController.tabBarItem.title = @"Settings";
	settingsViewController.navigationItem.title = @"Settings";
	navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	[viewControllers addObject:navigationController]; 
	[navigationController release];
	
	
	
	//NSArray* viewcontrollers = [NSArray arrayWithObjects:cameraViewController,receiptListViewController, reportViewController, settingsViewController, nil ];
    tabBarController.viewControllers = viewControllers;
	[viewControllers release];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	[self buildUIlayout];
	//Add the view controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
	[cameraViewController release];
	[reportViewController release];
	[receiptListViewController release];
	[settingsViewController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}


@end
