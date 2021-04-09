package com.example.myapplication;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.CamcorderProfile;
import android.media.MediaRecorder;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.provider.MediaStore;
import android.util.Log;
import android.view.KeyEvent;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class RecordActivity extends AppCompatActivity {
    private static int VIDEO_REQUEST = 101;
    private Uri videoUri = null;
   // private SurfaceView cameraView;
    private MediaRecorder recorder = null;
    private final String PATH_NAME = "/Users/kristinchin/Documents/Capstone " +
            "II/Capstone-II/AppVideos/";
    private final int FRAME_RATE = 30;
    private boolean toggled = true;
    private CountDownTimer cTimer = null;
    int START_TIME_IN_MILLIS = 10000;
    private long TimeLeftInMillis = START_TIME_IN_MILLIS;
    private ProgressBar progressBar;
    private TextView countdownTime;
    private static final String LOG_TAG = "AudioRecordTest";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.record);
        progressBar = findViewById(R.id.progressBar);
        countdownTime = findViewById(R.id.countdownTime);
        // cameraView = (SurfaceView) findViewById(R.id.cameraView);
//        try {
//            startRecording();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
    }

    // check if audio recording is permitted
    private boolean audioPermitted() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            if (ContextCompat.checkSelfPermission(this,
                    Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                // Permission is not granted
                return false;
            }
            return false;
        }
        return true;
    }


    // starts recording if audio is permitted, or requests permission
    private void startRecording() throws IOException {
        System.out.println("startRecording called");
        if (audioPermitted() == false) {
            ActivityCompat.requestPermissions(this, new String[] { Manifest.permission.RECORD_AUDIO },
                    10);
        }
        else {
            createRecording();
        }
    }

    // creates a new mediarecorder object and starts recording
    private void createRecording() {
        recorder = new MediaRecorder();

        recorder.setVideoSource(MediaRecorder.VideoSource.SURFACE);
        recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        try {
            recorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
        } catch (IllegalStateException e) {
            Log.e(LOG_TAG, "set OutputFormat failed");
        }
        try {
            recorder.setOutputFile(PATH_NAME);
        } catch (IllegalStateException e) {
            Log.e(LOG_TAG, "set output file failed");
        }
        recorder.setVideoFrameRate(30);
        //recorder.setVideoSize(videoSize.getWidth(), videoSize.getHeight());
        recorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264);
        recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
        //recorder.setVideoFrameRate(FRAME_RATE);


        //recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);

//        recorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264);
//        recorder.setVideoEncodingBitRate(CamcorderProfile.videoBitRate);

        try {
            recorder.prepare();
        } catch (IOException e) {
            Log.e(LOG_TAG, "prepare() failed");
        }
        recorder.start();
        startTimer();
        System.out.println("recording started");
    }

    // stops recording
    private void stopRecording() {
        recorder.stop();
        recorder.release();
        recorder = null;
        System.out.println("recording stopped");
        cancelTimer();
    }

    //start timer function for 60 seconds
    // When finished, stop recording
    private void startTimer() {
        int numberOfSeconds = START_TIME_IN_MILLIS/1000;
        int factor = 100/numberOfSeconds;
        cTimer = new CountDownTimer(START_TIME_IN_MILLIS, 1000) {
            public void onTick(long millisUntilFinished) {
                updateCountDownText(); //  Updating CountDown_Tv
                int secondsRemaining = (int) (millisUntilFinished / 1000);
                int progressPercentage = (numberOfSeconds-secondsRemaining) * factor;
                progressBar.setProgress(progressPercentage);
            }
            public void onFinish() {
                stopRecording();
            }
        };
        cTimer.start();
    }

    //updates countdown text based on time left on timer
    private void updateCountDownText() {
        int secondsLeft = (int) (TimeLeftInMillis / 1000);
        countdownTime.setText(secondsLeft + "s");
    }

    //cancel timer
    private void cancelTimer() {
        if(cTimer!=null)
            cTimer.cancel();
    }

//        Button recordButton =
//                (Button) findViewById(R.id.recordButton);
//
//        if (!hasCamera())
//            recordButton.setEnabled(false);


//    // if the volume up key is pressed, stop recording
//    public boolean dispatchKeyEvent(KeyEvent event) {
//        int action = event.getAction();
//        int keyCode = event.getKeyCode();
//        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP && action == KeyEvent.ACTION_UP) {
//            stopRecording();
//            return true;
//        }
//        return super.dispatchKeyEvent(event);
//    }


//    // toggles the start recording button
//    private void toggle() {
//        if (toggled == true) {
//            toggled = false;
//        } else {
//            toggled = true;
//        }
//    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    //    // starts video capture from external app
//    public void captureVideo() {
//        Intent takeVideoIntent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
//        if (takeVideoIntent.resolveActivity(getPackageManager()) != null) {
//            startActivityForResult(takeVideoIntent, VIDEO_REQUEST);
//        }
//    }

//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        if (requestCode == VIDEO_REQUEST && resultCode ==RESULT_OK) {
//            videoUri = data.getData();
//        }
//        super.onActivityResult(requestCode, resultCode, data);
//    }

//    private boolean hasCamera() {
//        if (getPackageManager().hasSystemFeature(
//                PackageManager.FEATURE_CAMERA_ANY)){
//            return true;
//        } else {
//            return false;
//        }
//    }
}
