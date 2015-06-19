//
//  ViewController.h
//  iOS OpenCV HelloWorld
//
//  Created by Local Joshua La Pine on 6/9/15.
//  Copyright (c) 2015 Local Joshua La Pine. All rights reserved.
//
#import <opencv2/highgui/cap_ios.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<CvVideoCameraDelegate>

@property IBOutlet UIImageView *imageView;
@property IBOutlet UIButton *button;
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (nonatomic) AVCaptureFocusMode focusMode;

- (IBAction)actionStart:(id)sender;

@end

