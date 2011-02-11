    //
//  CameraViewController.m
//  SnapReceipt
//
//  Created by Charles Adetiloye on 2/10/11.
//  Copyright 2011 MavenCode. All rights reserved.
//

#import "CameraViewController.h"
#import "baseapi.h"
#include <math.h>
static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation CameraViewController





// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
        // Custom initialization.
		[self startTesseract];	
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView 
{
	//self.title = @"Snap Receipt!";
	//self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
	
}*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark IBAction
- (IBAction) takePhoto:(id) sender
{
	imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:imagePickerController animated:YES];
}

- (IBAction) findPhoto:(id) sender
{
	imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark -
- (NSString *) applicationDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	return documentsDirectoryPath;
}



#pragma mark -
#pragma mark Image Processsing
- (void) startTesseract
{
	//code from http://robertcarlsen.net/2009/12/06/ocr-on-iphone-demo-1043
	
	NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
	/*
	 Set up the data in the docs dir
	 want to copy the data to the documents folder if it doesn't already exist
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:dataPath]) {
		// get the path to the app bundle (with the tessdata dir)
		NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
		NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
		if (tessdataPath) {
			[fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
		}
	}
	
	NSString *dataPathWithSlash = [[self applicationDocumentsDirectory] stringByAppendingString:@"/"];
	setenv("TESSDATA_PREFIX", [dataPathWithSlash UTF8String], 1);
	
	// init the tesseract engine.
	tessBaseAPI = new TessBaseAPI();
	
	tessBaseAPI->SimpleInit([dataPath cStringUsingEncoding:NSUTF8StringEncoding],  // Path to tessdata-no ending /.
					 "eng",  // ISO 639-3 string or NULL.
					 false);
		
}


- (NSString *) ocrImage: (UIImage *) uiImage
{
	// <MARCELO>
	
	CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void		   *bitmapData;
    int				bitmapByteCount;
    int             bitmapBytesPerRow;
    int             bitsPerComponent = 8;
	int				width;
	int				height;
	
	
	CGImageRef image = uiImage.CGImage;
	
	int numberOfComponents = 4;
	
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	CGRect imageRect = {{0,0},{width, height}};
	// Declare the number of bytes per row. Each pixel in the bitmap in this example is represented by 4 bytes; 8 bits each of red, green, blue, and  alpha.
	bitmapBytesPerRow   = (width * numberOfComponents);
	bitmapByteCount     = (bitmapBytesPerRow * height);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL) {
		CGColorSpaceRelease( colorSpace );
		return @"";
	}
	
	context = CGBitmapContextCreate (bitmapData, width, height, 
									 bitsPerComponent, bitmapBytesPerRow, colorSpace,
									 kCGImageAlphaPremultipliedFirst);//kCGImageAlphaNoneSkipFirst);//kCGImageAlphaNone);//
	if (context == NULL)  {
		free (bitmapData);
		CGColorSpaceRelease( colorSpace );
		return @"";
	}
	
	CGContextDrawImage(context, imageRect, image);
	CGColorSpaceRelease( colorSpace );
	void * buf = CGBitmapContextGetData (context);	
	
	NSDate *start = [NSDate date];
	
	char* text = tessBaseAPI->TesseractRect((unsigned char*)buf, 4, bitmapBytesPerRow, 0, 0, width, height);
	
	NSDate *end = [NSDate date];
	NSLog(@"%g", [end timeIntervalSinceDate:start]);
	
	free( buf );
	
	// Do something useful with the text!
	NSLog(@"Converted text: %@",[NSString stringWithCString:text encoding:NSUTF8StringEncoding]);
	
	return [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
}


// <MARCELO>
-(void)doOCR:(UIImage*)image
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *text = [self ocrImage:image];
	label.text = text;
	
	[pool release];
	
	[alert dismissWithClickedButtonIndex:0 animated:YES];
}
// </MARCELO>


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	
	// <MARCELO>
	alert = [[UIAlertView alloc] initWithTitle:@"OCRDemo" message:@"Working..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	
	[picker dismissModalViewControllerAnimated:YES];	
	[NSThread detachNewThreadSelector:@selector(doOCR:) toTarget:self withObject:image];
	// </MARCELO>
}
	

//http://www.iphonedevsdk.com/forum/iphone-sdk-development/7307-resizing-photo-new-uiimage.html#post33912
-(UIImage *)resizeImage:(UIImage *)image {
	
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
	
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	int width, height;
	
	width = [image size].width;
	height = [image size].height;
	
	CGContextRef bitmap;
	
	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	}
	
	if (image.imageOrientation == UIImageOrientationLeft) {
		NSLog(@"image orientation left");
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -height);
		
	} else if (image.imageOrientation == UIImageOrientationRight) {
		NSLog(@"image orientation right");
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -width, 0);
		
	} else if (image.imageOrientation == UIImageOrientationUp) {
		NSLog(@"image orientation up");	
		
	} else if (image.imageOrientation == UIImageOrientationDown) {
		NSLog(@"image orientation down");	
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, radians(-180.));
		
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;	
}



- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[iv release];
	[label release];
	[alert release];
	
    [super dealloc];
}


@end
