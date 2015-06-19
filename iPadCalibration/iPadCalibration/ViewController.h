//
//  ViewController.h
//  iPadCalibration
//
//  Created by Local Joshua La Pine on 6/15/15.
//  Copyright (c) 2015 Local Joshua La Pine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property IBOutlet UIView *view;
@property (weak) IBOutlet UISlider *slider;
@property (weak) IBOutlet UILabel *label;
@property (weak) IBOutlet UIButton *button;

-(IBAction)changeFocus:(id)sender;
-(IBAction)buttonFocus:(id)sender;
//- (void)updateLabel(id)time;
@property AVCaptureDevice *videoCaptureDevice;
@end

