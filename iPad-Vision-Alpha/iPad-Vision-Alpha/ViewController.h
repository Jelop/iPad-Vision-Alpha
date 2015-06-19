//
//  ViewController.h
//  iPad-Vision-Alpha
//
//  Created by Local Joshua La Pine on 6/19/15.
//  Copyright (c) 2015 Local Joshua La Pine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <opencv2/opencv.hpp>


@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property IBOutlet UIView *view;
@property AVCaptureDevice *videoCaptureDevice;
@property AVCaptureVideoDataOutput *videoDataOutput;
@property IBOutlet UIImageView *imageView;

- (void) fromSampleBuffer:(CMSampleBufferRef)sampleBuffer
toCVMat:(cv::Mat &)mat;
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;


@end

