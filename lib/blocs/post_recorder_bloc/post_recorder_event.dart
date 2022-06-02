import 'dart:io';

import 'package:fun_recorder/models/recording_filter_model.dart';

abstract class PostRecorderEvent {
  const PostRecorderEvent();
}

class PostRecorderRecordingStarted extends PostRecorderEvent {}

class PostRecorderRecordingResumed extends PostRecorderEvent {}

class PostRecorderRecordingStopped extends PostRecorderEvent {}

class PostRecorderPlaybackStarted extends PostRecorderEvent {}

class PostRecorderPlaybackPositionChanged extends PostRecorderEvent {
  final Duration position;

  const PostRecorderPlaybackPositionChanged(this.position);
}

class PostRecorderPlaybackEnded extends PostRecorderEvent {}

class PostRecorderPlaybackStopped extends PostRecorderEvent {}

class PostRecorderRecordingPositionChanged extends PostRecorderEvent {
  final Duration position;

  const PostRecorderRecordingPositionChanged(this.position);
}

class PostRecorderSegmentAmpsChanged extends PostRecorderEvent {
  final List<double> amps;

  const PostRecorderSegmentAmpsChanged(this.amps);
}

class PostRecorderPlaybackPaused extends PostRecorderEvent {}

class PostRecorderRecordingDeleted extends PostRecorderEvent {}

class PostRecorderSegmentDeleted extends PostRecorderEvent {
  final int deletedIndex;

  const PostRecorderSegmentDeleted(this.deletedIndex);
}

class PostRecorderSegmentFileProcessed extends PostRecorderEvent {
  final File file;

  const PostRecorderSegmentFileProcessed(this.file);
}

class PostRecorderFilterChanged extends PostRecorderEvent {
  final RecordingFilter filter;

  const PostRecorderFilterChanged(this.filter);
}

class PostRecorderSegmentSelected extends PostRecorderEvent {
  final int index;

  const PostRecorderSegmentSelected(this.index);
}

class PostRecorderSegmentUnselected extends PostRecorderEvent {}

class PostRecorderSegmentFilterChanged extends PostRecorderEvent {
  final int segmentIndex;
  final RecordingFilter filter;

  const PostRecorderSegmentFilterChanged(this.segmentIndex, this.filter);
}

class PostRecorderPlaybackSeekUpdated extends PostRecorderEvent {
  final Duration position;

  const PostRecorderPlaybackSeekUpdated(this.position);
}

class PostRecorderPlaybackSeekFinished extends PostRecorderEvent {}

class PostRecorderEventFinished extends PostRecorderEvent {}

class PostRecorderFiltersShown extends PostRecorderEvent {}

class PostRecorderFiltersHidden extends PostRecorderEvent {}
