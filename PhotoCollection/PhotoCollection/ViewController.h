//
//  ViewController.h
//  PhotoCollection
//
//  Created by Local Joshua La Pine on 6/18/15.
//  Copyright (c) 2015 Local Joshua La Pine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property IBOutlet UIView *view;
@property AVCaptureDevice *videoCaptureDevice;
@property (nonatomic, retain) AVCaptureStillImageOutput *photoOutput;
@property (nonatomic, retain) AVCaptureConnection *videoConnection;
@property IBOutlet UIButton *button;

-(IBAction) focusImage:(id)sender;
-(void) captureImage;
@end

