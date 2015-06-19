#include <opencv2/core/core.hpp>
#include <opencv2/video/tracking.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <iostream>

using namespace std;
using namespace cv;

int main(int argc, char** argv){

    VideoCapture cap;
    cap.open(0);
    Mat frame;
    Size boardSize(9,6);
    vector<Point3f> corners;

    for( int i = 0; i < boardSize.height; ++i ){
        for( int j = 0; j < boardSize.width; ++j ){
            corners.push_back(Point3f(float(j*28), float(i*28), 0));
        }
    }
    //cout << corners.size() << endl;
    /* for(int i = 0; i < corners.size(); i++){
        cout << corners[i] << endl;
        }*/

    FileStorage fs("camera_params.xml", FileStorage::READ);
    if(!fs.isOpened())
        cout << "File io is not working" << endl;
    
    Mat cameraMatrix, distCoeffs;
    fs["Camera_Matrix"] >> cameraMatrix;
    fs["Distortion_Coefficients"] >> distCoeffs;
    cout << cameraMatrix << endl;
    cout << distCoeffs << endl;
    //frame = imread(argv[1], CV_LOAD_IMAGE_COLOR);
    
       for(;;){
        cap >> frame;

        //Mat pixelcorners = Mat::zeros(54, 2, CV_32FC1);
        vector<Point2f> pixelcorners;
        //vector<Point3f> rvec;
        //vector<Point3f> tvec;
        Mat rvec;
        Mat tvec;
        bool vectors = false;
        // waitKey(2000);

        bool patternfound = findChessboardCorners(frame, boardSize, pixelcorners,
                          CALIB_CB_ADAPTIVE_THRESH + CALIB_CB_NORMALIZE_IMAGE
                                                  + CALIB_CB_FAST_CHECK);
        //      cout << Mat(pixelcorners) << endl;
        //cout << pixelcorners.size() << endl;
        //cout << "Hello!" << endl;
        if(patternfound){
          vectors = solvePnP(corners, pixelcorners, cameraMatrix, distCoeffs, rvec, tvec, false);
           }
        drawChessboardCorners(frame, boardSize, pixelcorners, patternfound);
        imshow("It worked!", frame);
        if(vectors){
        cout << "Rotation matrix: " << rvec << endl;
        cout << "Translation matrix: " <<tvec << endl;
        }
        waitKey(1);

        }
       
    return 0;
}
