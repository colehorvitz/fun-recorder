package com.example.fun_recorder;

import android.app.Activity;
import android.app.ZygotePreload;
import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.Handler;
import android.os.Looper;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;

import static android.media.AudioRecord.getMinBufferSize;

public class AudioRecorder {
    private static final int RECORDER_SAMPLE_RATE = 44100; // CHANGE TO 44.1K IN PRODUCTION
    private static final int RECORDER_CHANNELS = AudioFormat.CHANNEL_IN_MONO;
    private static final int RECORDER_AUDIO_ENCODING = AudioFormat.ENCODING_PCM_16BIT;
    private static final int RECORDER_AUDIO_ENCODING_BIT_RATE = 128000;
    private static final int delayMillis = 10;
    private boolean isRecording = false;
    private int bufferSizeInBytes = getMinBufferSize(RECORDER_SAMPLE_RATE, RECORDER_CHANNELS, RECORDER_AUDIO_ENCODING);
    private Context context;
    private EventSink eventSink;
    private MediaRecorder mediaRecorder;
    private String mediaPath;
    private Handler handler;
    private int durationMillis = 0;

    public AudioRecorder(Context applicationContext, final EventChannel eventChannel) {
        this.context = applicationContext;
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {

            @Override
            public void onListen(Object arguments, final EventSink eventSink) {
                AudioRecorder.this.eventSink = eventSink;
                mediaPath = arguments.toString();
                record();
            }

            @Override
            public void onCancel(Object arguments) {
                eventSink = null;
                durationMillis = 0;
                if (isRecording) {
                    mediaRecorder.stop();
                    isRecording = false;
                }

            }
        });
    }

    public void record() {
        mediaRecorder = new MediaRecorder();
        mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
        mediaRecorder.setOutputFile(mediaPath);
        mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
        mediaRecorder.setAudioSamplingRate(RECORDER_SAMPLE_RATE);
        mediaRecorder.setAudioEncodingBitRate(RECORDER_AUDIO_ENCODING_BIT_RATE);
        try {
            mediaRecorder.prepare();
        } catch (IOException e) {
            System.out.println(e.toString());
            Log.e("AudioRecorder", "prepare() failed");
            return;
        }
        mediaRecorder.start();
        setupHandler();
    }

    private void setupHandler() {
        handler = new Handler();
        handler.post(new Runnable() {
            @Override
            public void run() {
                if (mediaRecorder != null && eventSink != null) {
                    final Map<String, Object> event = new HashMap<>();
                    double amp = Math.min(mediaRecorder.getMaxAmplitude(), 25000) / 25000.;
                    event.put("amp", amp);
                    event.put("duration", durationMillis);
                    event.put("path", mediaPath);
                    eventSink.success(event);
                    handler.postDelayed(this, delayMillis);
                    durationMillis += delayMillis;
                }
            }
        });
    }
}
