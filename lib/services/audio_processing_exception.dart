class AudioProcessingException implements Exception {
  String cause;
  AudioProcessingException(this.cause);

  @override
  String toString() => "AudioProcessingException: $cause";
}
