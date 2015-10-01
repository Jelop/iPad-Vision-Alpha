//
//  ViewController.m
//  iOS OpenCV HelloWorld
//
//  Created by Local Joshua La Pine on 6/9/15.
//  Copyright (c) 2015 Local Joshua La Pine. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/opencv.hpp>

using namespace cv;

cv::Size boardSize(9,6);
vector<Point3f> corners;
vector<Point3f> polypoints;
Mat cameraMatrix, distCoeffs;

@implementation ViewController


@synthesize videoCaptureDevice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [videoCaptureDevice lockForConfiguration:nil];
    [videoCaptureDevice setVideoZoomFactor:1];
    [videoCaptureDevice setFocusModeLockedWithLensPosition:0.7 completionHandler: nil];
    [videoCaptureDevice unlockForConfiguration];

    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    self.videoCamera.delegate = self;
    [self.videoCamera lockFocus];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    //self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    
    cameraMatrix = Mat::eye(3, 3, CV_64F);
    distCoeffs = Mat::zeros(8, 1, CV_64F);

    for( int i = 0; i < boardSize.height; ++i ){
        for( int j = 0; j < boardSize.width; ++j ){
            corners.push_back(Point3f(float(j*28), float(i*28), 0));
        }
    }
    
   NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *myFile = [mainBundle pathForResource: @"params_0.7" ofType: @"xml"];
    //std::string *path = new std::string([myFile UTF8String]);
    const char *path = [myFile UTF8String];
    
    FileStorage fs(path, FileStorage::READ);
    if(!fs.isOpened())
        std::cout << "File io is not working" << std::endl;
    
    fs["Camera_Matrix"] >> cameraMatrix;
    fs["Distortion_Coefficients"] >> distCoeffs;
    fs.release();
    
    polypoints.push_back(Point3f(float(0), float(0), float(0)));
    polypoints.push_back(Point3f(float(56), float(0), float(0)));
    polypoints.push_back(Point3f(float(56), float(56), float(0)));
    polypoints.push_back(Point3f(float(0), float(56), float(0)));
    
    polypoints.push_back(Point3f(float(0), float(0), float(-56)));
    polypoints.push_back(Point3f(float(56), float(0), float(-56)));
    polypoints.push_back(Point3f(float(56), float(56), float(-56)));
    polypoints.push_back(Point3f(float(0), float(56), float(-56)));


    
}

- (IBAction)actionStart:(id)sender{
   
    [self.videoCamera start];
    [videoCaptureDevice lockForConfiguration:nil];
    [videoCaptureDevice setVideoZoomFactor:1];
    [videoCaptureDevice setFocusModeLockedWithLensPosition:0.7 completionHandler: nil];
    [videoCaptureDevice unlockForConfiguration];
}

#ifdef __cplusplus


#define res_x 1920
#define res_y 1080

struct blob{
    Point2i topleft;
    Point2i botright;
    int row;
    int col;
    int count;
};

vector<blob> blobs;

-(int) findBlobs:(cv::Mat&) image{
    
    //cout << "in findBlobs" << endl;
    //Mat image;
    //image.copyTo(image);
    // cout << "about to enter for" << endl;
    for(int row = 0; row < image.rows; row++){
        for(int col = 0; col < image.cols; col++){
            if(image.at<uchar>(row,col) == 0){
                //cout << "in if" << endl;
                bool blob_exists = false;
                for(int k = 0; k < blobs.size(); k++){
                    //cout << "iterating over blob vector" << endl;
                    if(row >= blobs[k].topleft.x && row <= blobs[k].botright.x &&
                       col >= blobs[k].topleft.y && col <= blobs[k].botright.y){
                        //cout << "added to existing blob" << endl;
                        blobs[k].row += row;
                        blobs[k].col += col;
                        blobs[k].count++;
                        blob_exists = true;
                        break;
                    }
                }
                
                if(!blob_exists){
                    
                    // might need to make the box a square...
                    
                    /* if(row - 10 < 0 || col - 75 < 0 ||
                     row + 210 > res_y || col + 125 > res_x){
                     cout << " early termination" << endl;
                     return -1;
                     }*/
                    
                    //cout << "creating new blob" << endl;
                    blobs.push_back(blob());
                    int index = blobs.size()-1;
                    
                    blobs[index].topleft = Point2i(row - 10, col - 75);
                    blobs[index].botright = Point2i(row + 210, col + 125);
                    blobs[index].row = row;
                    blobs[index].col = col;
                    blobs[index].count = 1;
                    std::cout << "successfully created new blob" << std::endl;
                    
                }
            }
        }
    }
    return 0;
}

- (void) processImage:(cv::Mat &)image{
    
    blobs.clear();
    cv::Mat copy;
    image.copyTo(copy);
    copy.convertTo(image, CV_8U);
    
    threshold(image, image, 50, 255, THRESH_BINARY);
    
    [self findBlobs:image];
    
    std::cout << "before cirlce drawing" << std::endl;
    for(int i = 0; i < blobs.size(); i++){
        int x = blobs[i].col/blobs[i].count;
        int y = blobs[i].row/blobs[i].count;
        std::cout << "circle " << i << " x = " << x << std::endl;
        std::cout << "circle " << i << " y = " << y << std::endl;
        cv::Point center(cvRound(x), cvRound(y));
        cv::circle(image, center, 3, cv::Scalar(255,0,0), -1, 8, 0);
    }

    
    
    
    
    
    
    
    
    /*[videoCaptureDevice lockForConfiguration:nil];
    [videoCaptureDevice setVideoZoomFactor:1];
    [videoCaptureDevice setFocusModeLockedWithLensPosition:0.7 completionHandler: nil];
    [videoCaptureDevice unlockForConfiguration];*/
    //NSLog([NSString stringWithFormat:@"%1.9f", videoCaptureDevice.lensPosition]);
    //vector<Point2f> pixelcorners;
    //vector<vector<Point2f> > vecpixelcorners(1);
    //vector<Point2f> imagepoints;
    //Mat rvec, tvec;
    //bool vectors = false;
    /*bool patternfound = findChessboardCorners(image, boardSize, pixelcorners,
                                              CALIB_CB_ADAPTIVE_THRESH + CALIB_CB_NORMALIZE_IMAGE
                                              + CALIB_CB_FAST_CHECK);*/
    /*drawChessboardCorners(image, boardSize, pixelcorners, patternfound);*/
    
    //Mat gray_image;
    //std::cout << vecpixelcorners.size() << " " << corners.size() << std::endl;
    //cvtColor(image, gray_image, CV_RGB2GRAY );
    //cv::Size imageSize = gray_image.size();
    //vecpixelcorners.push_back(pixelcorners);
    //corners.resize(vecpixelcorners.size(), corners[0]);
    /*if(patternfound && !pixelcorners.empty()){
        vectors = solvePnP(corners, pixelcorners, cameraMatrix, distCoeffs, rvec, tvec, false);
        //vectors = calibrateCamera(corners, vecpixelcorners, imageSize, cameraMatrix, distCoeffs, rvec, tvec);
    }*/
    
    /*if(vectors){
        //cout << "Rotation matrix: " << rvec << endl;
        //cout << "Translation matrix: " <<tvec << endl;
        projectPoints(polypoints, rvec, tvec, cameraMatrix, distCoeffs, imagepoints);
        line(image, imagepoints[0], imagepoints[1], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[1], imagepoints[2], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[2], imagepoints[3], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[3], imagepoints[0], Scalar(0,255,0), 5, 8);
        
        line(image, imagepoints[0], imagepoints[4], Scalar(0,0,255), 5, 8);
        line(image, imagepoints[1], imagepoints[5], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[2], imagepoints[6], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[3], imagepoints[7], Scalar(255,0,0), 5, 8);
        
        line(image, imagepoints[4], imagepoints[5], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[5], imagepoints[6], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[6], imagepoints[7], Scalar(255,0,0), 5, 8);
        line(image, imagepoints[7], imagepoints[4], Scalar(255,0,0), 5, 8);
    }*/

}
#endif
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
