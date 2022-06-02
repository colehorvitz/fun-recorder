import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/recording_filter_model.dart';
import '../models/recording_segment_model.dart';
import '../services/audio_processor.dart';

class RecorderRepository {
  final AudioProcessor _processor;

  const RecorderRepository(this._processor);

  Future<Directory> get _tmp async => await getTemporaryDirectory();

  Future<String> _tempFilePath(String ext) async =>
      '${(await _tmp).path}${Platform.pathSeparator}${DateTime.now().microsecondsSinceEpoch}$ext';

  Future<String> get tempRecordingPath async => Platform.isAndroid
      ? await tempAndroidRecordingPath
      : await tempIosRecordingPath;

  Future<String> get tempAndroidRecordingPath async =>
      await _tempFilePath('.m4a');

  Future<String> get tempIosRecordingPath async => await _tempFilePath('.wav');

  Future<File> concatDemux(List<File> files) async {
    final path = await tempRecordingPath;
    return await _processor.concatDemux(files, path);
  }

  Future<File> applyFilter(RecordingFilter filter, File file) async {
    switch (filter) {
      case RecordingFilter.high:
        return _applyHighPitchFilter(file);
      case RecordingFilter.low:
        return _applyLowPitchFilter(file);
      case RecordingFilter.robot:
        return _applyRobotFilter(file);
      case RecordingFilter.echo:
        return _applyEchoFilter(file);
      case RecordingFilter.wobble:
        return _applyWobbleFilter(file);
      case RecordingFilter.reverse:
        return _applyReverseFilter(file);
      case RecordingFilter.loud:
        return _applyLoudFilter(file);
      default:
        return file;
    }
  }

  Future<File> replaceSegmentFilter(
    List<RecordingSegmentModel> segments,
    int selectedSegmentIndex,
    RecordingFilter newFilter,
    File fullRecording,
  ) async {
    final selectedSegment = segments[selectedSegmentIndex];
    final filtered = await applyFilter(newFilter, selectedSegment.file);
    if (segments.length == 1) {
      // segment is first and last segment
      return filtered;
    } else if (selectedSegmentIndex == 0) {
      // segment is first index
      final trimmed = await _processor.trimFile(selectedSegment.endPosition,
          segments.last.endPosition, fullRecording, await tempRecordingPath);
      return await concatDemux([filtered, trimmed]);
    } else if (selectedSegmentIndex == segments.length - 1) {
      // segment is last index
      final trimmed = await _processor.trimFile(
          Duration.zero,
          selectedSegment.startPosition,
          fullRecording,
          await tempRecordingPath);
      return await concatDemux([trimmed, filtered]);
    } else {
      // segment is in middle
      final trimmed1 = await _processor.trimFile(
          Duration.zero,
          selectedSegment.startPosition,
          fullRecording,
          await tempRecordingPath);
      final trimmed2 = await _processor.trimFile(selectedSegment.endPosition,
          segments.last.endPosition, fullRecording, await tempRecordingPath);
      return await concatDemux([trimmed1, filtered, trimmed2]);
    }
  }

  Future<File> deleteSegment(List<RecordingSegmentModel> segments,
      int deletedIndex, File fullRecording) async {
    if (segments.length <= 1) {
      return null;
    }
    final toDelete = segments[deletedIndex];
    if (deletedIndex == 0) {
      final trimmed = await _processor.trimFile(toDelete.endPosition,
          segments.last.endPosition, fullRecording, await tempRecordingPath);
      return trimmed;
    } else if (deletedIndex == segments.length - 1) {
      final trimmed = await _processor.trimFile(Duration.zero,
          toDelete.startPosition, fullRecording, await tempRecordingPath);
      return trimmed;
    } else {
      final trimmed1 = await _processor.trimFile(Duration.zero,
          toDelete.startPosition, fullRecording, await tempRecordingPath);
      final trimmed2 = await _processor.trimFile(toDelete.endPosition,
          segments.last.endPosition, fullRecording, await tempRecordingPath);
      return await concatDemux([trimmed1, trimmed2]);
    }
  }

  Future<File> _applyHighPitchFilter(File file) async {
    return await _processor.adjustPitch(1.75, file, await tempRecordingPath);
  }

  Future<File> _applyLowPitchFilter(File file) async {
    return await _processor.adjustPitch(0.75, file, await tempRecordingPath);
  }

  Future<File> _applyRobotFilter(File file) async {
    return await _processor.applyRobotFilter(file, await tempRecordingPath);
  }

  Future<File> _applyEchoFilter(File file) async {
    return await _processor.applyEchoFilter(file, await tempRecordingPath);
  }

  Future<File> _applyWobbleFilter(File file) async {
    return await _processor.applyWobbleFilter(file, await tempRecordingPath);
  }

  Future<File> _applyReverseFilter(File file) async {
    return await _processor.applyReverseFilter(file, await tempRecordingPath);
  }

  Future<File> _applyLoudFilter(File file) async {
    return await _processor.applyLoudFilter(file, await tempRecordingPath);
  }

  Future<void> deleteFiles(List<File> files) async {
    for (final file in files) {
      if (file.existsSync()) await file.delete();
    }
  }
}
