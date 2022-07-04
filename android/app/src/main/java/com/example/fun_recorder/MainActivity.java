package com.example.fun_recorder;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example.fun_recorder/recorder";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        EventChannel eventChannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        AudioRecorder audioRecorder = new AudioRecorder(getApplicationContext(), eventChannel);
    }
}
