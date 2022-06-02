class AudioRecorderException implements Exception {
  String cause;
  AudioRecorderException(this.cause);

  @override
  String toString() => "AudioRecorderException: $cause";
}
