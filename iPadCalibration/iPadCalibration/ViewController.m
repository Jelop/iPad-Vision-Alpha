//
//  ViewController.m
//  iPadCalibration
//
//  Created by Local Joshua La Pine on 6/15/15.
//  Copyright (c) 2015 Local Joshua La Pine. All rights reserved.
//

#import "ViewController.h"

int count = 0;
float lens = 0;

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
   /* NSNumber *value = [NSNumber numberWithInt:1];
    [[UIDevice currentDevice]setValue:value forKey:@"orientation"];*/
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    _videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [_videoCaptureDevice lockForConfiguration:nil];
    [_videoCaptureDevice setFocusMode:0];
    [_videoCaptureDevice unlockForConfiguration];
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:_videoCaptureDevice error: &error];
    NSLog(@"This works");
    if(videoInput){
        [session addInput:videoInput];
    } else {
        NSLog(@"For some reason the device has no camera?");
    }
    
    
   /*AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc ]init];
    [session addOutput:videoOutput];*/
    
    /*AVCaptureStillImageOutput *photoOutput = [[AVCaptureStillImageOutput alloc]init];
    [photoOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    [session addOutput:photoOutput];*/
    
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.frame = self.view.bounds;
    //preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:preview];
    
    [self.view addSubview:_slider];
    [self.view addSubview:_label];
    [self.view addSubview:_button];
    [_slider setValue:0];
    lens = _videoCaptureDevice.lensPosition;
    [session startRunning];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate{
    return NO;
}

- (IBAction)changeFocus:(id)sender{
    [_videoCaptureDevice lockForConfiguration:nil];
    [_videoCaptureDevice setFocusModeLockedWithLensPosition:_slider.value  completionHandler:nil];
    [_videoCaptureDevice unlockForConfiguration];
    _label.text = [NSString stringWithFormat:@"%1.9f",_videoCaptureDevice.lensPosition];
    if(lens != _videoCaptureDevice.lensPosition){
        lens = _videoCaptureDevice.lensPosition;
        count++;
        printf("Count = %d\n", count);
    }
}
    
    
- (IBAction)buttonFocus:(id)sender{
    [_videoCaptureDevice lockForConfiguration:nil];
    [_videoCaptureDevice setFocusModeLockedWithLensPosition: 0.5  completionHandler:^(CMTime syncTime ) {
     _label.text = [NSString stringWithFormat:@"%1.9f",_videoCaptureDevice.lensPosition];
    }];
    [_videoCaptureDevice unlockForConfiguration];
   // _label.text = [NSString stringWithFormat:@"%1.9f",_videoCaptureDevice.lensPosition];
    
}


@end
