import 'dart:io';

import 'package:equatable/equatable.dart';

import 'recording_filter_model.dart';

class RecordingSegmentModel extends Equatable {
  final Duration startPosition;
  final Duration endPosition;
  final List<double> amps;
  final File file;
  final RecordingFilter filter;

  Duration get duration => endPosition - startPosition;

  const RecordingSegmentModel(
    this.amps,
    this.startPosition,
    this.endPosition,
    this.file,
    this.filter,
  );

  RecordingSegmentModel copyWith(
      {Duration startPosition,
      Duration endPosition,
      List<double> amps,
      File file,
      RecordingFilter filter}) {
    return RecordingSegmentModel(
        amps ?? this.amps,
        startPosition ?? this.startPosition,
        endPosition ?? this.endPosition,
        file ?? this.file,
        filter ?? this.filter);
  }

  @override
  List<Object> get props => [startPosition, endPosition, amps, file, filter];

  @override
  String toString() {
    return "RecordingSegmentModel(start: $startPosition, end: $endPosition, amps length: ${amps.length}, file: $file, filter: $filter)";
  }
}
