import 'dart:io';

abstract class AudioFileUploadEvent {}

class AudioFileUploaded extends AudioFileUploadEvent {
  final String filePath;

  AudioFileUploaded(this.filePath);
}

class AudioFileErrorDismissed extends AudioFileUploadEvent {}
