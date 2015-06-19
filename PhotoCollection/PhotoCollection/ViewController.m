//
//  ViewController.m
//  PhotoCollection
//
//  Created by Local Joshua La Pine on 6/18/15.
//  Copyright (c) 2015 Local Joshua La Pine. All rights reserved.
//

#import "ViewController.h"

float focus = 0.6;
int count = 0;

@implementation ViewController

@synthesize photoOutput;
@synthesize videoConnection;
@synthesize videoCaptureDevice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   /* UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(takePhoto:)];
    [self.view addGestureRecognizer:singleFingerTap];*/
    
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [videoCaptureDevice lockForConfiguration:nil];
    [videoCaptureDevice setVideoZoomFactor:1];
    [videoCaptureDevice setFocusMode:0];
    [videoCaptureDevice unlockForConfiguration];
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error: &error];
    NSLog(@"This works");
    if(videoInput){
        [session addInput:videoInput];
    } else {
        NSLog(@"For some reason the device has no camera?");
    }

    [self.view addSubview:_button];
    
    photoOutput = [[AVCaptureStillImageOutput alloc]init];
    [photoOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    [session addOutput:photoOutput];
    
  
    
        /*dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    [photoOutput setSampleBufferDelegate:self queue:queue];*/

    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.frame = self.view.bounds;
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:preview];
    [session startRunning];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate{
    
    return NO;
}

- (IBAction)focusImage:(id)sender{
    
    if(count % 3 == 0){
        focus = 0.6;
    }
    
    focus += 0.1;

    //[videoConnection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeOff];
    
    
    NSLog(@"Button Pressed");
    
        [videoCaptureDevice lockForConfiguration:nil];
        [videoCaptureDevice setFocusModeLockedWithLensPosition:focus completionHandler:^(CMTime syncTime ) {
            NSLog([NSString stringWithFormat:@"%1.9f", videoCaptureDevice.lensPosition]);
            [self captureImage];
        }];
        [videoCaptureDevice unlockForConfiguration];
    count++;
}

- (void) captureImage{
    
    
    videoConnection = nil;
    for (AVCaptureConnection *connection in photoOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [photoOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        //if (imageDataSampleBuffer)
        //{
        //NSLog(@"Photo saved");
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
        //}
    }];
}


@end
