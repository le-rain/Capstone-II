package com.example.myapplication;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

// MainActivity Class that represents the functions and features of the first welcome screen.
public class MainActivity extends AppCompatActivity {

    EditText inputAge;
    EditText inputWeight;
    EditText inputHeight;
    Button btn;
    Button skipBtn;
    String age = null;
    String weight = null;
    String height = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        inputAge = findViewById(R.id.inputAge);
        inputHeight = findViewById(R.id.inputHeight);
        inputWeight = findViewById(R.id.inputWeight);

        btn = findViewById(R.id.buttonNext1);
        skipBtn = findViewById(R.id.skipButton);


        // onCLick listener for 'Next' button
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this,
                        Direction1Activity.class));
//                if (age != null && weight != null && height != null) {
//                    age = inputAge.getText().toString();
//                    weight = inputWeight.getText().toString();
//                    height = inputHeight.getText().toString();
//
//                    if (Integer.parseInt(age) > 0
//                            && Integer.parseInt(weight) > 0
//                            && Integer.parseInt(height) > 0) {
//                        System.out.print("Age: " + age + "\nheight: " + height
//                                + " \nweight: " + weight + "\n");
//                        startActivity(new Intent(MainActivity.this,
//                                Direction1Activity.class));
//                    } else {
//                        displayErrorMessage();
//                    }
//                } else {
//                    displayErrorMessage();
//                }
            }
        });

        skipBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                age = inputAge.getText().toString();
                weight = inputWeight.getText().toString();
                height = inputHeight.getText().toString();
                System.out.print("Age: " + age + "\nheight: " + height + " \nweight: " + weight + "\n");
                startActivity(new Intent(MainActivity.this, CameraActivity.class));

            }
        });

    }

    // displays message if user does not fill in all fields
    private void displayErrorMessage() {
        Context context = getApplicationContext();
        CharSequence text = "Please complete in all fields with valid (positive) inputs.";
        int duration = Toast.LENGTH_SHORT;

        Toast toast = Toast.makeText(context, text, duration);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.show();
    }


//    EditText editText = (EditText) findViewById(R.id.inputName);
//    editText.setOnEditorActionListener(new OnEditorActionListener() {
//        @Override
//        public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
//            boolean handled = false;
//            if (actionId == EditorInfo.IME_ACTION_SEND) {
//                sendMessage();
//                handled = true;
//            }
//            return handled;
//        }
//    });
}