package com.example.myapplication;

import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.OpenCVFrameConverter;
import org.bytedeco.javacv.OpenCVFrameGrabber;
import org.bytedeco.opencv.opencv_core.Mat;

import java.io.File;

//This class processes the video and contains methods to calculate BP from the video.

class VidProcessor {

    public static Mat readVid(String fileName) throws Exception {

        OpenCVFrameConverter.ToMat converterToMat = new OpenCVFrameConverter.ToMat();

        String videoFileName = fileName;
        File f = new File(videoFileName);

        OpenCVFrameGrabber grabber = null;
        grabber = OpenCVFrameGrabber.createDefault(f);
        grabber.start();
        try {
            grabber = OpenCVFrameGrabber.createDefault(f);
            grabber.start();
        } catch (Exception e) {
            System.err.println("Failed to start the grabber.");
        }

        Frame videoFrame;
        Mat videoMat = null;
        while (true) {
            videoFrame = grabber.grab();
            videoMat = converterToMat.convert(videoFrame);
            return videoMat;
        }
    }
}
