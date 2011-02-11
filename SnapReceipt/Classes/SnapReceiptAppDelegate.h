//
//  SnapReceiptAppDelegate.h
//  SnapReceipt
//
//  Created by Charles Adetiloye on 2/10/11.
//  Copyright 2011 MavenCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController, ReportViewController, ReceiptListViewController, SettingsViewController;

@interface SnapReceiptAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	
	UITabBarController			*tabBarController;
	
	CameraViewController		*cameraViewController;
	ReportViewController		*reportViewController;
	ReceiptListViewController	*receiptListViewController;
	SettingsViewController		*settingsViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) CameraViewController		*cameraViewController;
@property (nonatomic, retain) ReportViewController		*reportViewController;
@property (nonatomic, retain) ReceiptListViewController	*receiptListViewController;
@property (nonatomic, retain) SettingsViewController	*settingsViewController;


@end

