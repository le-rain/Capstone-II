// API References
// Camera API - https://developer.android.com/guide/topics/media/camera
// Record Video API - https://developer.android.com/training/camera/videobasics
// Custom Camera - https://developer.android.com/guide/topics/media/camera#custom-camera
// Camera2 example (not same as android.hardware.camera, but  - https://github.com/android/camera-samples/blob/main/Camera2Video/app/src/main/java/com/example/android/camera2/video/fragments/CameraFragment.kt*/

package com.example.myapplication;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.VideoView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class CameraActivity2 extends AppCompatActivity {

    Uri videoUri;
    Button recordButton;
    VideoView videoView;
    Button playbackButton;
    Button restartButton;
    Button processButton;
    private static final String TAG = "Cuffless BP";

    // when activity is created, check for camera
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.camera_activity);

//        recordButton = (Button) findViewById(R.id.record);
//        videoView = findViewById(R.id.videoview);
//        playbackButton = findViewById(R.id.playback);
//        restartButton = findViewById(R.id.restart);
//        processButton = findViewById(R.id.process);

//        //checks for camera
//        if (!hasCamera())
//            recordButton.setEnabled(false);

        setButtonListeners();
    }

    // Set button listeners
    private void setButtonListeners() {
        recordButton = (Button) findViewById(R.id.record);
        videoView = findViewById(R.id.videoview);
        playbackButton = findViewById(R.id.playback);
        restartButton = findViewById(R.id.restart);
        processButton = findViewById(R.id.process);

        //set listener for record button
        recordButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startRecording(v);
            }
        });

        // set onClick function for playback button
        playbackButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (videoUri == null) {
                    Log.d(TAG, "No video");
                } else {
                    videoView.setVideoURI(videoUri);
                    videoView.start();
                }
            }
        });

        // set onClick function for restart button
        restartButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(CameraActivity2.this, MainActivity.class);
                startActivity(intent);
            }
        });

        //sets listener for process button
        processButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    VidProcessor.readVid(videoUri.toString());
                } catch (Exception e) {
                    ;
                }
            }
        });
    }

    //checks if phone has camera
    private boolean hasCamera() {
        return (getPackageManager().hasSystemFeature(
                PackageManager.FEATURE_CAMERA_ANY));
    }

    private static final int VIDEO_CAPTURE = 101;

    //starts the recording
    public void startRecording(View view) {
        Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        videoUri = getOutputVideoUri();  // create a file to save the video in specific folder
        if (videoUri != null) {
            intent.putExtra(MediaStore.EXTRA_OUTPUT, videoUri);
        }
        intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1); // set the video image quality to high
        startActivityForResult(intent, VIDEO_CAPTURE);
    }

//    // when activity produces a result
//    protected void onActivityResult(int requestCode,
//                                    int resultCode, Intent data) {
//
//        super.onActivityResult(requestCode, resultCode, data);
//        videoUri = data.getData();
//
//        if (requestCode == VIDEO_CAPTURE) {
//            if (resultCode == RESULT_OK) {
//                Toast.makeText(this, "Video saved to:\n" +
//                        videoUri, Toast.LENGTH_LONG).show();
//            } else if (resultCode == RESULT_CANCELED) {
//                Toast.makeText(this, "Video recording cancelled.",
//                        Toast.LENGTH_LONG).show();
//            } else {
//                Toast.makeText(this, "Failed to record video",
//                        Toast.LENGTH_LONG).show();
//            }
//        }
//    }

    // sets a Uri and returns it
    public Uri getOutputVideoUri() {
        if (Environment.getExternalStorageState() == null) {
            return null;
        }

        File mediaStorage =
                new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), "CufflessBPVid");
        if (!mediaStorage.exists() &&
                !mediaStorage.mkdirs()) {
            Log.e("Vid Processor: ", "failed to create directory: " + mediaStorage);
            return null;
        }

        // Create a media file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date());
        File mediaFile = new File(mediaStorage, "VID_" + timeStamp + ".mp4");

        Uri fileUri = FileProvider.getUriForFile(getApplicationContext(), getPackageName()+".fileprovider", mediaFile);
        System.out.println("File Uri = " + fileUri.toString());
        return fileUri;
        //return Uri.fromFile(mediaFile);
    }

//        val processButton: Button = findViewById(R.id.process)
//        processButton.setOnClickListener {
//            if (videoUri == null) {
//                Log.d(TAG, "No video")
//            } else {
//                val f = File(videoUri.toString())
//                videoProcessor = VideoProcessor()
//                videoProcessor!!.open(videoUri!!.path.toString())
//
//                val fullUri = videoProcessor!!.videoUri
//                Log.d(TAG, fullUri)
//                val isOpened = videoProcessor!!.isOpened;
//                val frameNum = videoProcessor!!.frameNumber;
//                Log.d(TAG, "Number of frames: $frameNum");
//
//                val videoLength = videoProcessor!!.videoLength;
//                Log.d(TAG, "Video Length: $videoLength");
//
//                if (isOpened) {
//                    Log.d(TAG, "VideoProcessor Opened")
//                } else {
//                    Log.d(TAG, "VideoProcessor Not Opened")
//                }
//            }
//        }*/

    // Create an instance of Camera
//        mCamera = getCameraInstance()
//        mCamera?.setDisplayOrientation(90)
//
//        mPreview = mCamera?.let {
//            // Create our Preview view
//            CameraPreview(this, it)
//        }

    // Set the Preview view as the content of our activity.
//        mPreview?.also {
//            val preview: FrameLayout = findViewById(R.id.camera_preview)
//            preview.addView(it)
//        }


//        else if (requestCode == CHOOSE_VIDEO && resultCode == RESULT_OK){
//            if (intent?.data != null) {
//                val videoURI = intent?.data
//                currentPhotoPath = videoURI?.path.toString()
//                Log.d(TAG, currentPhotoPath)
//                playVideoInDevicePlayer()
////                videoView?.setVideoURI(videoURI)
////                videoView?.start()
//            }
//        }

//    fun playVideoInDevicePlayer() {
//        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(currentPhotoPath))
//        intent.setDataAndType(Uri.parse(currentPhotoPath), "video/mp4")
//        startActivity(intent)
//    }

//    /** A safe way to get an instance of the Camera object. */
//    private fun getCameraInstance(): Camera? {
//        return try {
//            Camera.open(1) // attempt to get a Camera instance
//        } catch (e: Exception) {
//            // Camera is not available (in use or does not exist)
//            null // returns null if camera is unavailable
//        }
//    }

//    private fun prepareVideoRecorder(): Boolean {
//
//        mediaRecorder = MediaRecorder()
//
//        mCamera?.let { camera ->
//            // Step 1: Unlock and set camera to MediaRecorder
//            camera.unlock()
//
//            mediaRecorder?.run {
//                setCamera(camera)
//
//                // Step 2: Set sources
//                setAudioSource(MediaRecorder.AudioSource.MIC)
//                setVideoSource(MediaRecorder.VideoSource.CAMERA)
//
//                // Step 3: Set a CamcorderProfile (requires API Level 8 or higher)
//                setProfile(CamcorderProfile.get(CamcorderProfile.QUALITY_HIGH))
//
//                // Step 4: Set output file
//                setOutputFile(currentPhotoPath)
//
//                // Step 5: Set the preview output
//                setPreviewDisplay(mPreview?.holder?.surface)
//
//                // Step 6: Prepare configured MediaRecorder
//                return try {
//                    prepare()
//                    true
//                } catch (e: IllegalStateException) {
//                    Log.d(TAG, "IllegalStateException preparing MediaRecorder: ${e.message}")
//                    releaseMediaRecorder()
//                    false
//                } catch (e: IOException) {
//                    Log.d(TAG, "IOException preparing MediaRecorder: ${e.message}")
//                    releaseMediaRecorder()
//                    false
//                }
//            }
//
//        }
//        return false
//    }

//    private fun createVideoFile(): File {
//        // Create an image file name
//        val timeStamp: String = SimpleDateFormat("MMdd_HHmmss").format(Date())
//        val storageDir: File? = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
//        return File.createTempFile(
//                "cuffless_bp_${timeStamp}", /* prefix */
//                ".mp4", /* suffix */
//                storageDir /* directory */
//        ).apply {
//            // Save a file: path for use with ACTION_VIEW intents
//            currentPhotoPath = absolutePath
//        }
//    }

//    /** Create a File for saving an image or video */
//    private fun getOutputMediaFile(type: Int): File? {
//        // To be safe, you should check that the SDCard is mounted
//        // using Environment.getExternalStorageState() before doing this.
//
//        val mediaStorageDir = File(
//                Environment.getExternalFilesDir(),
//                "CufflessBP"
//        )
//        // This location works best if you want the created images to be shared
//        // between applications and persist after your app has been uninstalled.
//
//        // Create the storage directory if it does not exist
//        mediaStorageDir.apply {
//            if (!exists()) {
//                if (!mkdirs()) {
//                    Log.d("CufflessBP", "failed to create directory")
//                    return null
//                }
//            }
//        }
//
//        // Create a media file name
//        val timeStamp = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
//        return when (type) {
//            MEDIA_TYPE_IMAGE -> {
//                File("${mediaStorageDir.path}${File.separator}IMG_$timeStamp.jpg")
//            }
//            MEDIA_TYPE_VIDEO -> {
//                File("${mediaStorageDir.path}${File.separator}VID_$timeStamp.mp4")
//            }
//            else -> null
//        }
//    }

//    override fun onPause() {
//        super.onPause()
//        releaseMediaRecorder()
//        releaseCamera()
//    }
//
//    private fun releaseMediaRecorder() {
//        mediaRecorder?.release()
//        mediaRecorder?.reset() // clear recorder configuration
//        mediaRecorder = null
//        mCamera?.lock() // lock camera for later use
//    }
//
//    private fun releaseCamera() {
//        mCamera?.release()
//        mCamera = null
//    }
}
