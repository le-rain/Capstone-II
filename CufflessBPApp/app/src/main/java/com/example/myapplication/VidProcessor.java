package com.example.myapplication;

import android.net.Uri;
import android.os.Environment;
import android.util.Log;

import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.OpenCVFrameConverter;
import org.bytedeco.javacv.OpenCVFrameGrabber;
import org.bytedeco.opencv.opencv_core.Mat;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

//This class processes the video and contains methods to calculate BP from the video.

class VidProcessor {

    public static Uri getOutputVideoUri() {
        if (Environment.getExternalStorageState() == null) {
            return null;
        }

        File mediaStorage =
                new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), "CufflessBPVId");
        if (!mediaStorage.exists() &&
                !mediaStorage.mkdirs()) {
            Log.e("Vid Processor: ", "failed to create directory: " + mediaStorage);
            return null;
        }

        // Create a media file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date());
        File mediaFile = new File(mediaStorage, "VID_" + timeStamp + ".mp4");
        return Uri.fromFile(mediaFile);
    }


    public static Mat readVid(String fileName) throws Exception {

        OpenCVFrameConverter.ToMat converterToMat = new OpenCVFrameConverter.ToMat();
        System.out.println("converterToMat failed");

//        if (args.length < 2) {
//            System.out.println("Two parameters are required to run this program, first parameter " +
//                    "is the analyzed video and second parameter is the trained result for fisher faces.");
//        }

        String videoFileName = fileName;
        System.out.println("File Name: " + videoFileName);
        //String trainedResult = args[1];

//        CascadeClassifier face_cascade = new CascadeClassifier(
//                "data\\haarcascade_frontalface_default.xml");
//        FaceRecognizer lbphFaceRecognizer = LBPHFaceRecognizer.create();
//        lbphFaceRecognizer.read(trainedResult);

        File f = new File(videoFileName);

        OpenCVFrameGrabber grabber = null;

        grabber = OpenCVFrameGrabber.createDefault(f);
        grabber.start();
//        try {
//            grabber = OpenCVFrameGrabber.createDefault(f);
//            grabber.start();
//        } catch (Exception e) {
//            System.err.println("Failed to start the grabber.");
//        }

        Frame videoFrame;
        Mat videoMat = null;
//        while (true) {
//            videoFrame = grabber.grab();
//            videoMat = converterToMat.convert(videoFrame);
            // Mat videoMatGray = new Mat();
            // Convert the current frame to grayscale:
//            cvtColor(videoMat, videoMatGray, COLOR_BGRA2GRAY);
//            equalizeHist(videoMatGray, videoMatGray);
//
//            Point p = new Point();
//            RectVector faces = new RectVector();
//            // Find the faces in the frame:
//            face_cascade.detectMultiScale(videoMatGray, faces);
//
//            // At this point you have the position of the faces in
//            // faces. Now we'll get the faces, make a prediction and
//            // annotate it in the video. Cool or what?
//            for (int i = 0; i < faces.size(); i++) {
//                Rect face_i = faces.get(i);
//
//                Mat face = new Mat(videoMatGray, face_i);
//                // If fisher face recognizer is used, the face need to be
//                // resized.
//                // resize(face, face_resized, new Size(im_width, im_height),
//                // 1.0, 1.0, INTER_CUBIC);
//
//                // Now perform the prediction, see how easy that is:
//                IntPointer label = new IntPointer(1);
//                DoublePointer confidence = new DoublePointer(1);
//                lbphFaceRecognizer.predict(face, label, confidence);
//                int prediction = label.get(0);
//
//                // And finally write all we've found out to the original image!
//                // First of all draw a green rectangle around the detected face:
//                rectangle(videoMat, face_i, new Scalar(0, 255, 0, 1));
//
//                // Create the text we will annotate the box with:
//                String box_text = "Prediction = " + prediction;
//                // Calculate the position for annotated text (make sure we don't
//                // put illegal values in there):
//                int pos_x = Math.max(face_i.tl().x() - 10, 0);
//                int pos_y = Math.max(face_i.tl().y() - 10, 0);
//                // And now put it into the image:
//                putText(videoMat, box_text, new Point(pos_x, pos_y),
//                        FONT_HERSHEY_PLAIN, 1.0, new Scalar(0, 255, 0, 2.0));
////            }
//            // Show the result:
//            imshow("Video", videoMat);
//
//            char key = (char) waitKey(20);
//            // Exit this loop on escape:
//            if (key == 27) {
//                destroyAllWindows();
//                break;
//            }
//        }
//        System.out.print(videoMat);
        return videoMat;
    }
}
