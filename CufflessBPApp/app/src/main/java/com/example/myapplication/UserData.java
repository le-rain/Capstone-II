//package com.example.myapplication;
//
//import android.content.Context;
//import android.content.SharedPreferences;
//import android.view.View;
//import android.widget.Button;
//import android.widget.EditText;
//import android.widget.TextView;
//
//// this class represents the measurement data including the user's age, height, weight, and their
//// video file
//// an instance of this class will be created each time the user takes a new measurement
//public class UserData extends MainActivity {
//    int time;
//    int date;
//    int measurementNum;
//    double age;
//    double weight;
//    double height;
//
//    public UserData(int time, int date, int measurementNum, double age, double weight,
//                    double height) {
////        time = getTime();
////        date = getDate();
////        measurementNum = setMeasurementNum();
//        age = getAge();
//        weight = getWeight();
//        height = getHeight();
//    }
//
//    // returns the string of the given EditText
//    public String store_input(EditText inputText) {
//        String text = inputText.getText().toString();
//        return text;
//    }
//
//    // returns input age as a double
//    private double getAge(EditText inputAge) {
//        String ageStr;
//        double ageVar;
//        ageStr = store_input(inputAge);
//        ageVar = Double.parseDouble(ageStr);
//        return ageVar;
//    }
//
//    // returns input weight as a double (in lbs)
//    private double getWeight(EditText inputWeight) {
//        String weightStr;
//        double weightVar;
//        weightStr = store_input(inputWeight);
//        weightVar = Double.parseDouble(weightStr);
//        return weightVar;
//    }
//
//    // returns input height as a double (in inches)
//    private double getHeight(EditText inputHeight) {
//        String heightStr;
//        double heightVar;
//        heightStr = store_input(inputHeight);
//        heightVar = Double.parseDouble(heightStr);
//        return heightVar;
//    }
//
//    // TODO: create method to export timestamp, age, weight, height into excel
//    // create method to export video file to desktop
//    // create method to call set weight
//    // figure out when to create instance of class
//}
