import 'dart:io';

import 'package:equatable/equatable.dart';

class RecordingData extends Equatable {
  final File file;
  final List<double> amps;
  final Duration duration;

  RecordingData(this.file, this.amps, this.duration);

  @override
  List<Object> get props => [file, amps, duration];
}
