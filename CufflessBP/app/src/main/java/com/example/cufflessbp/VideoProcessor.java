package com.example.cufflessbp;


import android.annotation.SuppressLint;
import android.util.Log;

import org.opencv.android.OpenCVLoader;
import org.opencv.core.Core;
import org.opencv.videoio.VideoCapture;

import org.opencv.android.OpenCVLoader;
import org.opencv.android.Utils;
import org.opencv.core.Mat;
import org.opencv.imgproc.Imgproc;
import org.opencv.videoio.Videoio;

import java.lang.annotation.Native;

import static android.content.ContentValues.TAG;


public class VideoProcessor {

    private String videoUri;
    private VideoCapture cap;

    public VideoProcessor() {
        boolean opened = OpenCVLoader.initDebug();

//
//        try {
//            Log.d(TAG, Core.NATIVE_LIBRARY_NAME);
//            System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
//        } catch (Exception e) {
//            Log.d(TAG, "Didnt Load");
//        }
        this.cap = new VideoCapture();
    }

    public VideoProcessor(String videoUri) {
        this.videoUri = videoUri;
        this.cap = new VideoCapture(videoUri);
    }

    public boolean isOpened() {
        return this.cap.isOpened();
    }

    public String getVideoUri() {
        return this.videoUri;
    }

    public boolean open(String fileName) {
        this.videoUri = fileName;
        return this.cap.open(fileName);
    }

    public int getFrameNumber() {
        int frame_number = (int) cap.get(Videoio.CAP_PROP_POS_FRAMES);
        return frame_number;
    }

    public int getVideoLength() {
        int video_length = (int) cap.get(Videoio.CAP_PROP_FRAME_COUNT);
        return video_length;
    }

}

