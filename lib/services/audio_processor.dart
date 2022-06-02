import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'audio_processing_exception.dart';

class AudioProcessor {
  final FlutterFFmpeg _fFmpeg;
  final _flutterFFmpegConfig = FlutterFFmpegConfig();

  AudioProcessor(this._fFmpeg);

  Future<File> convertToM4a(File file, String outputPath) async {
    if (!outputPath.endsWith('.m4a')) {
      throw AudioProcessingException('Output path must end with .m4a');
    }
    if (outputPath == file.path) {
      throw AudioProcessingException('Output path may not be input path');
    }
    final conversionCommand =
        "-i ${file.path} -map 0:a -codec:a aac $outputPath";
    final conversionResult = await _fFmpeg.execute(conversionCommand);
    if (conversionResult != 0) {
      throw AudioProcessingException("Failed to convert file to M4A");
    }
    final output = File(outputPath);
    if (!output.existsSync()) {
      throw AudioProcessingException(
          "Failed to convert file to M4A: Output file was not created");
    }
    return output;
  }

  Future<File> concatDemux(List<File> files, String outputPath) async {
    if (files.length == 0) {
      throw AudioProcessingException("Failed to concat: no fiels inputted");
    }
    var commandPrefix = '';
    for (final file in files) {
      commandPrefix = '$commandPrefix -i ${file.path}';
    }
    final command =
        "$commandPrefix -filter_complex '[0:a][1:a]concat=n=${files.length}:v=0:a=1[a]' -map '[a]' $outputPath";
    final result = await _fFmpeg.execute(command);
    if (result != 0) {
      throw AudioProcessingException("Failed concat: status code $result");
    }
    return File(outputPath);
  }

  Future<File> compressFile(File file, String outputPath,
      [int bitRate = 96]) async {
    assert(outputPath != file.path);
    // Change 64k to 96k for better quality, bigger file
    final compressionCommand =
        "-i ${file.path} -map 0:a:0 -b:a ${bitRate}k $outputPath";
    final conversionResult = await _fFmpeg.execute(compressionCommand);
    if (conversionResult != 0) {
      throw AudioProcessingException(
          "Failed to compress file: error code $conversionResult");
    }
    final output = File(outputPath);
    if (!output.existsSync()) {
      throw AudioProcessingException(
          "Failed to compress file: Output file was not created");
    }
    return output;
  }

  Future<File> trimFile(
      Duration start, Duration end, File file, String outputPath) async {
    final arg = "-i ${file.path} -ss $start -t $end $outputPath";
    final result = await _fFmpeg.execute(arg);
    if (result != 0) {
      throw AudioProcessingException(
          "Failed clipping track: status code $result");
    }
    return File(outputPath);
  }

  Future<File> adjustPitch(
      double pitchFactor, File file, String outputPath) async {
    final arg =
        "-i ${file.path} -af 'asetrate=44100*$pitchFactor,atempo=${1 / pitchFactor}' $outputPath";
    final result = await _fFmpeg.execute(arg);
    if (result != 0) {
      throw AudioProcessingException(
          "Failed to adjust pitch: status code $result");
    }
    return File(outputPath);
  }

  Future<File> applyRobotFilter(File file, String outputPath) async {
    final arg =
        '''-i ${file.path} -filter_complex "afftfilt=real='hypot(re,im)*sin(0)':imag='hypot(re,im)*cos(0)':win_size=512:overlap=0.5" $outputPath''';
    final result = await _fFmpeg.execute(arg);
    if (result != 0) {
      throw AudioProcessingException(
          "Failed to apply robot filter: status code $result");
    }
    return File(outputPath);
  }

  Future<File> applyEchoFilter(File file, String outputPath) async {
    final arg =
        '''-i ${file.path} -filter_complex "aecho=0.8:0.9:500|1000:0.2|0.1" $outputPath''';
    final result = await _fFmpeg.execute(arg);
    if (result != 0) {
      throw AudioProcessingException(
          "Failed to apply echo filter: status code $result");
    }
    return File(outputPath);
  }

  Future<File> applyWobbleFilter(File file, String outputPath) async {
    final arg =
        '''-i ${file.path} -filter_complex "vibrato=f=10" $outputPath''';
    final result = await _fFmpeg.execute(arg);
    if (result != 0) {
      throw AudioProcessingException(
          "Failed to apply wobble filter: status code $result");
    }
    return File(outputPath);
  }

  Future<File> applyReverseFilter(File file, String outputPath) async {
    final arg = '''-i ${file.path} -filter_complex "areverse" $outputPath''';
    final result = await _fFmpeg.execute(arg);
    if (result != 0) {
      throw AudioProcessingException(
          "Failed to apply reverse filter: status code $result");
    }
    return File(outputPath);
  }

  Future<File> applyLoudFilter(File file, String outputPath) async {
    final arg =
        '''-i ${file.path} -filter_complex "acrusher=level_in=4:level_out=5:bits=8:mode=log:aa=1" $outputPath''';
    final result = await _fFmpeg.execute(arg);
    if (result != 0) {
      throw AudioProcessingException(
          "Failed to apply loud filter: status code $result");
    }
    return File(outputPath);
  }
}
