package com.example.myapplication;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

// Activity class for the first direction view.
public class Direction1Activity extends AppCompatActivity {
    Button btn2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.direction1);
        btn2 = (Button)findViewById(R.id.buttonNext2);

        // onClick listener for next button
        btn2.setOnClickListener(v -> startActivity(new Intent(Direction1Activity.this,
                Direction2Activity.class)));
    }
}