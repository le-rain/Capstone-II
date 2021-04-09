package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

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