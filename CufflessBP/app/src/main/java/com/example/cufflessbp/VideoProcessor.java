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

import java.lang.annotation.Native;

import static android.content.ContentValues.TAG;


public class VideoProcessor {

    private String videoUri;
    private VideoCapture cap;

    public VideoProcessor() {
        boolean opened = OpenCVLoader.initDebug();
        if (opened) {Log.d(TAG, "Not loading");}
        try {
            Log.d(TAG, Core.NATIVE_LIBRARY_NAME);
            System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        } catch (Exception e) {
            Log.d(TAG, "Didnt Load");
        }

        this.cap = new VideoCapture(videoUri);
    }

    public VideoProcessor(String videoUri) {
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        this.videoUri = videoUri;
        this.cap = new VideoCapture(videoUri);
    }

    public boolean isOpened() {
        return this.isOpened();
    }

    public String getVideoUri() {
        return this.videoUri;
    }

    public boolean open(String fileName) {
        this.videoUri = fileName;
        return this.open(fileName);
    }


}

