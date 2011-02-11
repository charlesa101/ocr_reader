//
//  CameraViewController.h
//  SnapReceipt
//
//  Created by Charles Adetiloye on 2/10/11.
//  Copyright 2011 MavenCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseapi.h"

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	UIImagePickerController *imagePickerController;
	TessBaseAPI				*tessBaseAPI;
	UIImageView *iv;
	UILabel *label;
	UIAlertView *alert;
}

- (IBAction) findPhoto:(id) sender;
- (IBAction) takePhoto:(id) sender;

- (void) startTesseract;

- (NSString*)	applicationDocumentsDirectory;
- (NSString*)	ocrImage: (UIImage *) uiImage;
- (UIImage*)	resizeImage:(UIImage *)image;

@end
