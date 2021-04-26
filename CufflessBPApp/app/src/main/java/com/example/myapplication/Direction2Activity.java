package com.example.myapplication;

import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

// Activity class for the second direction view.
public class Direction2Activity extends AppCompatActivity {

    Button readyBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.direction2);

        readyBtn = findViewById(R.id.buttonNext3);
        readyBtn.setOnClickListener(v -> startActivity(new Intent(Direction2Activity.this,
                CameraActivity.class)));
    }

    // listens for volume up button press and release and starts the measurement activity
    public boolean dispatchKeyEvent(KeyEvent event) {
        int action = event.getAction();
        int keyCode = event.getKeyCode();

        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP && action == KeyEvent.ACTION_UP) {
            startActivity(new Intent(Direction2Activity.this, CameraActivity.class));
            return true;
        }
        return super.dispatchKeyEvent(event);
    }
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
