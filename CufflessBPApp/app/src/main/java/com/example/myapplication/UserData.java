package com.example.myapplication;

import android.content.Context;
import android.content.SharedPreferences;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

// this class represents the user's data including their age, height, weight
// an instance of this class will be created each time the user takes a new measurement
public class UserData extends MainActivity {
    TextView textIntro;
    TextView inputName;
    TextView inputAge;
    TextView inputWeight;
    TextView inputHeight;

    public static void setUsername(Context context, String username) {
        SharedPreferences prefs = context.getSharedPreferences("myAppPackage", 0);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString("username", username);
        editor.commit();
    }

    public static String getUsername(Context context) {
        SharedPreferences prefs = context.getSharedPreferences("myAppPackage", 0);
        return prefs.getString("username", "");

    }
}
