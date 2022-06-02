import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';
import 'package:fun_recorder/models/recording_segment_model.dart';

enum PlaybackStatus { initial, loading, playing, waiting, done }

enum RecordingStatus { initial, waiting, recording, processing }

abstract class PostRecorderState extends Equatable {
  final List<RecordingSegmentModel> segments;
  final PlaybackStatus playbackStatus;
  final RecordingStatus recordingStatus;
  final Duration recordingPosition;
  final Duration playbackPosition;
  final File recording;
  final RecordingFilter filter;
  final int selectedSegmentIndex;
  final bool showFilters;

  Duration get duration => segments.fold<Duration>(
      Duration.zero, (prev, curr) => prev + curr.duration);

  const PostRecorderState(
    this.segments,
    this.playbackStatus,
    this.recordingStatus,
    this.recordingPosition,
    this.playbackPosition,
    this.recording,
    this.filter,
    this.selectedSegmentIndex,
    this.showFilters,
  );

  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  });

  @override
  List<Object> get props => [
        segments,
        playbackStatus,
        recordingStatus,
        recordingPosition,
        playbackPosition,
        recording,
        filter,
        selectedSegmentIndex,
        showFilters,
      ];
}

class PostRecorderInitial extends PostRecorderState {
  PostRecorderInitial(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  ) : super(
            segments,
            playbackStatus,
            recordingStatus,
            recordingPosition,
            playbackPosition,
            recording,
            filter,
            selectedSegmentIndex,
            showFilters);

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderInitial(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
      );
}

class PostRecorderIdle extends PostRecorderState {
  const PostRecorderIdle(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  ) : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderIdle(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
      );
}

class PostRecorderRecordingStartInProgress extends PostRecorderState {
  final String path;

  const PostRecorderRecordingStartInProgress(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
    this.path,
  ) : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );
  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderRecordingStartInProgress(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
        this.path,
      );
}

class PostRecorderRecordingStopInProgress extends PostRecorderState {
  const PostRecorderRecordingStopInProgress(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  ) : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderRecordingStopInProgress(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
      );
}

class PostRecorderPlaybackStartInProgress extends PostRecorderState {
  const PostRecorderPlaybackStartInProgress(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  ) : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderPlaybackStartInProgress(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
      );
}

class PostRecorderPlaybackEndInProgress extends PostRecorderState {
  const PostRecorderPlaybackEndInProgress(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  ) : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderPlaybackEndInProgress(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
      );
}

class PostRecorderPlaybackLoadInProgress extends PostRecorderState {
  final File loadedFile;

  const PostRecorderPlaybackLoadInProgress(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
    this.loadedFile,
  ) : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderPlaybackLoadInProgress(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
        this.loadedFile,
      );
}

class PostRecorderPlaybackStopInProgress extends PostRecorderState {
  const PostRecorderPlaybackStopInProgress(
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  ) : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderPlaybackStopInProgress(
        segments ?? this.segments,
        playbackStatus ?? this.playbackStatus,
        recordingStatus ?? this.recordingStatus,
        recordingPosition ?? this.recordingPosition,
        playbackPosition ?? this.playbackPosition,
        filter ?? this.filter,
        recording ?? this.recording,
        selectedSegmentIndex ?? this.selectedSegmentIndex,
        showFilters ?? this.showFilters,
      );
}

class PostRecorderPlaybackSeekInProgress extends PostRecorderState {
  final Duration position;

  const PostRecorderPlaybackSeekInProgress(
      List<RecordingSegmentModel> segments,
      PlaybackStatus playbackStatus,
      RecordingStatus recordingStatus,
      Duration recordingPosition,
      Duration playbackPosition,
      RecordingFilter filter,
      File recording,
      int selectedSegmentIndex,
      bool showFilters,
      this.position)
      : super(
          segments,
          playbackStatus,
          recordingStatus,
          recordingPosition,
          playbackPosition,
          recording,
          filter,
          selectedSegmentIndex,
          showFilters,
        );

  @override
  PostRecorderState copyWith({
    List<RecordingSegmentModel> segments,
    PlaybackStatus playbackStatus,
    RecordingStatus recordingStatus,
    Duration recordingPosition,
    Duration playbackPosition,
    RecordingFilter filter,
    File recording,
    int selectedSegmentIndex,
    bool showFilters,
  }) =>
      PostRecorderPlaybackSeekInProgress(
          segments ?? this.segments,
          playbackStatus ?? this.playbackStatus,
          recordingStatus ?? this.recordingStatus,
          recordingPosition ?? this.recordingPosition,
          playbackPosition ?? this.playbackPosition,
          filter ?? this.filter,
          recording ?? this.recording,
          selectedSegmentIndex ?? this.selectedSegmentIndex,
          showFilters ?? this.showFilters,
          position);
}
