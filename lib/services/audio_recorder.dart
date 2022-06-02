import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'audio_recorder_exception.dart';
import 'recording_data.dart';

class AudioRecorder {
  static const _platform =
      const EventChannel('com.example.fun_recorder/recorder');

  final StreamController _dataController = StreamController<RecordingData>();

  StreamSubscription _platformEventSubscription;
  File _recording;
  List<double> _amps;
  Duration _duration;

  Stream<RecordingData> get recordingDataStream => _dataController.stream;

  Future<void> startRecording(String filePath) async {
    final file = File(filePath);
    if (file.existsSync()) {
      throw AudioRecorderException(
          'Unable to start recording: file already exists');
    }
    try {
      _recording = await File(filePath).create();
    } catch (e) {
      throw AudioRecorderException('Unable to start recording: $e');
    }
    final eventStream = _platform.receiveBroadcastStream(_recording.path);
    _amps = <double>[];
    _platformEventSubscription = eventStream.listen((data) {
      if (data['amp'] == null || data['duration'] == null) {
        throw AudioRecorderException(
            'Received malformed data: Expected amp and duration keys');
      }
      _duration = Duration(milliseconds: data['duration']);
      _amps.add(data['amp']);

      _dataController.add(RecordingData(_recording, _amps, _duration));
    });
  }

  Future<File> stopRecording() async {
    if (_recording == null || _platformEventSubscription == null) {
      return null;
    }
    await _platformEventSubscription.cancel();
    return _recording;
  }

  Future<void> deleteRecording() async {
    if (_recording == null) {
      return;
    }
    if (_recording.existsSync()) {
      _recording.deleteSync();
    }
  }

  Future<void> tearDown() async {
    if (_platformEventSubscription != null) {
      await _platformEventSubscription.cancel();
    }
    await _dataController.close();
  }
}
