// API References
// Camera API - https://developer.android.com/guide/topics/media/camera
// Record Video API - https://developer.android.com/training/camera/videobasics
// Custom Camera - https://developer.android.com/guide/topics/media/camera#custom-camera
// Camera2 example (not same as android.hardware.camera, but  - https://github.com/android/camera-samples/blob/main/Camera2Video/app/src/main/java/com/example/android/camera2/video/fragments/CameraFragment.kt

package com.example.cufflessbp

import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.widget.Button
import android.widget.VideoView
import java.io.File

const val REQUEST_VIDEO_CAPTURE = 1
const val CHOOSE_VIDEO = 2


class CameraActivity : Activity() {
//    private var mCamera: Camera? = null
//    private var mPreview: SurfaceView? = null
//    private var mediaRecorder: MediaRecorder? = null // media recorder object (records video)
    private var videoView: VideoView? = null
    private var videoUri: Uri? = null
    private var videoProcessor: VideoProcessor? = null
//    private lateinit var currentPhotoPath: String

    // initializes layout, camera, preview surface (preview of video), and capture button info
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


        val processButton: Button = findViewById(R.id.process)
        processButton.setOnClickListener {
            if (videoUri == null) {
                Log.d(TAG, "No video")
            } else {
                val f = File(videoUri.toString())
                videoProcessor = VideoProcessor()
                videoProcessor!!.open(videoUri!!.path.toString())

                val fullUri = videoProcessor!!.videoUri
                Log.d(TAG, fullUri)
                val isOpened = videoProcessor!!.isOpened;
                val frameNum = videoProcessor!!.frameNumber;
                Log.d(TAG, "Number of frames: $frameNum");

                val videoLength = videoProcessor!!.videoLength;
                Log.d(TAG, "Video Length: $videoLength");

                if (isOpened) {
                    Log.d(TAG, "VideoProcessor Opened")
                } else {
                    Log.d(TAG, "VideoProcessor Not Opened")
                }
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
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent) {
        super.onActivityResult(requestCode, resultCode, intent)
        if (requestCode == REQUEST_VIDEO_CAPTURE && resultCode == RESULT_OK) {
            if (intent?.data != null) {
                videoUri = intent?.data
//                currentPhotoPath = videoURI?.path.toString()
            }
            galleryAddVideo() // adds video to gallery
        }

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
    }

    private fun galleryAddVideo() {
        Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE).also { mediaScanIntent ->
            val f = File(videoUri.toString()) //

            Log.d(TAG, Uri.fromFile(f).toString())

            mediaScanIntent.data = Uri.fromFile(f)

            sendBroadcast(mediaScanIntent)
        }
    }



    private fun openGalleryForVideo() {
        val intent = Intent()
        intent.type = "video/*"
        intent.action = Intent.ACTION_PICK
        startActivityForResult(Intent.createChooser(intent, "Select Video"), CHOOSE_VIDEO)
    }

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