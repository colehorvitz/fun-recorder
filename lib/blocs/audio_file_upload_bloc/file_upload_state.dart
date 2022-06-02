import 'dart:io';

import 'package:equatable/equatable.dart';

class AudioFileUploadState extends Equatable {
  @override
  List<Object> get props => [];
}

class AudioFileUploadInitial extends AudioFileUploadState {}

class AudioFileUploadTooLongFailure extends AudioFileUploadState {}

class AudioFileUploadTooShortFailure extends AudioFileUploadState {}

class AudioFileUploadSuccess extends AudioFileUploadState {
  final File file;

  AudioFileUploadSuccess(this.file);
  @override
  List<Object> get props => [file];
}
