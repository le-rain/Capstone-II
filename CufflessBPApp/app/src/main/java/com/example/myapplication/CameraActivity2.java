// API References
// Camera API - https://developer.android.com/guide/topics/media/camera
// Record Video API - https://developer.android.com/training/camera/videobasics
// Custom Camera - https://developer.android.com/guide/topics/media/camera#custom-camera
// Camera2 example (not same as android.hardware.camera, but  - https://github.com/android/camera-samples/blob/main/Camera2Video/app/src/main/java/com/example/android/camera2/video/fragments/CameraFragment.kt*/

package com.example.myapplication;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.VideoView;

import androidx.appcompat.app.AppCompatActivity;

public class CameraActivity2 extends AppCompatActivity {

    Uri videoUri;
    Button recordButton;
    VideoView videoView;
    Button playbackButton;
    Button restartButton;
    Button processButton;
    String videoPath;
    private static final String TAG = "Cuffless BP";
    private static final int REQUEST_TAKE_GALLERY_VIDEO = 1;


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
                    openGallery();
                    //VidProcessor.readVid(videoPath);
                } catch (Exception e) {
                    System.out.print("Could not process video");
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
//        videoUri = getOutputVideoUri();  // create a file to save the video in specific folder
//        if (videoUri != null) {
//            intent.putExtra(MediaStore.EXTRA_OUTPUT, videoUri);
//        }
//        intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1); // set the video image quality to high
        startActivityForResult(intent, VIDEO_CAPTURE);
    }

    public void openGallery() {
        Intent intent = new Intent();
        intent.setType("video/*");
        setResult(RESULT_OK, intent);
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent,"Select Video"),REQUEST_TAKE_GALLERY_VIDEO);
    }

//////    // when activity produces a result
//    protected void onActivityResult(int requestCode,
//                                    int resultCode, Intent data) {
////
//        super.onActivityResult(requestCode, resultCode, data);
//        videoUri = data.getData();
//        super.onActivityResult(requestCode, resultCode, data);
//        if(resultCode==RESULT_OK)
//        {
//
//            Uri vid = data.getData();
//            videoPath = getRealPathFromURI(vid);
//            System.out.println("Video Path: " + videoPath);
//        }
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

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (requestCode == REQUEST_TAKE_GALLERY_VIDEO) {
                Uri selectedImageUri = data.getData();

                // OI FILE Manager
                //String filemanagerstring = selectedImageUri.getPath();

                // MEDIA GALLERY
                videoPath = getPath(selectedImageUri);
                System.out.print("VideoPath: " + videoPath);
            }
        }
    }

    // UPDATED!
    public String getPath(Uri uri) {
        String[] projection = { MediaStore.Video.Media.DATA };
        Cursor cursor = getContentResolver().query(uri, projection, null, null, null);
        if (cursor != null) {
            // HERE YOU WILL GET A NULLPOINTER IF CURSOR IS NULL
            // THIS CAN BE, IF YOU USED OI FILE MANAGER FOR PICKING THE MEDIA
            int column_index = cursor
                    .getColumnIndexOrThrow(MediaStore.Video.Media.DATA);
            cursor.moveToFirst();
            System.out.print("Get Path was called");
            return cursor.getString(column_index);
        } else
            System.out.print("Get Path was called");
            return null;
    }

//    public String getRealPathFromURI(Uri contentUri) {
//        String[] proj = { MediaStore.Images.Media.DATA };
//        Cursor cursor = managedQuery(contentUri, proj, null, null, null);
//        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
//        cursor.moveToFirst();
//        return cursor.getString(column_index);
//    }
}
