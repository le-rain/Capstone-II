// API References
// Camera API - https://developer.android.com/guide/topics/media/camera
// Record Video API - https://developer.android.com/training/camera/videobasics
// Custom Camera - https://developer.android.com/guide/topics/media/camera#custom-camera
// Camera2 example (not same as android.hardware.camera, but  - https://github.com/android/camera-samples/blob/main/Camera2Video/app/src/main/java/com/example/android/camera2/video/fragments/CameraFragment.kt

package com.example.myapplication

import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.widget.Button
import android.widget.VideoView
import java.io.File
import java.text.SimpleDateFormat

const val REQUEST_VIDEO_CAPTURE = 1

class CameraActivity : Activity() {

    private var videoView: VideoView? = null
    var videoUri: Uri? = null

    //    // initializes layout, camera, preview surface (preview of video), and capture button info
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.camera_activity)

        videoView = findViewById(R.id.videoview)

        // set onClick function for playback button
        val playbackButton: Button = findViewById(R.id.playback)
        playbackButton.setOnClickListener {
            if (videoUri == null) {
                Log.d(TAG, "No video")
            } else {
                videoView?.setVideoURI(videoUri);
                videoView?.start();
            }
        }

        // set onclick function for record button
        val captureButton: Button = findViewById(R.id.record)
        captureButton.setOnClickListener {
            Intent(MediaStore.ACTION_VIDEO_CAPTURE).also { takeVideoIntent ->
                takeVideoIntent.resolveActivity(packageManager)?.also {
                    startActivityForResult(takeVideoIntent, REQUEST_VIDEO_CAPTURE)
                }
            }
        }

        // onClick listener for restart button
        val restartButton: Button = findViewById(R.id.restart)
        restartButton.setOnClickListener {
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent);
        }

        val processButton: Button = findViewById(R.id.process)
        processButton.setOnClickListener {
            val intent = Intent(this, ResultsActivity::class.java)
            startActivity(intent);
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent) {
        super.onActivityResult(requestCode, resultCode, intent)
        if (requestCode == REQUEST_VIDEO_CAPTURE && resultCode == RESULT_OK) {
            if (intent?.data != null) {
                videoUri = intent?.data
            }
        }
    }
}



