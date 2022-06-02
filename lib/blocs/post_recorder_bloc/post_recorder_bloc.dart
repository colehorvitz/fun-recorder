import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/data/post_recorder_repository.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';
import 'package:fun_recorder/models/recording_segment_model.dart';

import 'post_recorder_event.dart';
import 'post_recorder_state.dart';

class PostRecorderBloc extends Bloc<PostRecorderEvent, PostRecorderState> {
  PostRecorderBloc(this._repository)
      : super(PostRecorderInitial(
          const [],
          PlaybackStatus.initial,
          RecordingStatus.initial,
          Duration.zero,
          Duration.zero,
          RecordingFilter.normal,
          null,
          -1,
          false,
        )) {
    on<PostRecorderEventFinished>(_onPostRecorderEventFinished);
    on<PostRecorderRecordingPositionChanged>(
        _onPostRecorderRecordingPositionChanged);
    on<PostRecorderPlaybackPositionChanged>(
        _onPostRecorderPlaybackPositionChanged);
    on<PostRecorderRecordingStarted>(_onPostRecorderRecordingStarted);
    on<PostRecorderRecordingResumed>(_onPostRecorderRecordingResumed);
    on<PostRecorderRecordingStopped>(_onPostRecorderRecordingStopped);
    on<PostRecorderSegmentFileProcessed>(_onPostRecorderSegmentFileProcessed);
    on<PostRecorderPlaybackStarted>(_onPostRecorderPlaybackStarted);
    on<PostRecorderSegmentAmpsChanged>(_onPostRecorderSegmentAmpsChanged);
    on<PostRecorderPlaybackEnded>(_onPostRecorderPlaybackEnded);
    on<PostRecorderPlaybackStopped>(_onPostRecorderPlaybackStopped);
    on<PostRecorderFilterChanged>(_onPostRecorderFilterChanged);
    on<PostRecorderSegmentSelected>(_onPostRecorderSegmentSelected);
    on<PostRecorderSegmentUnselected>(_onPostRecorderSegmentUnselected);
    on<PostRecorderSegmentFilterChanged>(_onPostRecorderSegmentFilterChanged);
    on<PostRecorderSegmentDeleted>(_onPostRecorderSegmentDeleted);
    on<PostRecorderRecordingDeleted>(_onPostRecorderRecordingDeleted);
    on<PostRecorderPlaybackSeekUpdated>(_onPostRecorderPlaybackSeekUpdated);
    on<PostRecorderPlaybackSeekFinished>(_onPostRecorderPlaybackSeekFinished);
    on<PostRecorderFiltersShown>(_onPostRecorderFiltersShown);
    on<PostRecorderFiltersHidden>(_onPostRecorderFiltersHidden);
  }

  final RecorderRepository _repository;

  void _onPostRecorderRecordingStarted(PostRecorderRecordingStarted event,
      Emitter<PostRecorderState> emit) async {
    final path = await _repository.tempRecordingPath;
    emit(PostRecorderRecordingStartInProgress([
      RecordingSegmentModel(
          [], Duration.zero, Duration.zero, File(path), state.filter)
    ],
        state.playbackStatus,
        RecordingStatus.recording,
        state.recordingPosition,
        state.playbackPosition,
        state.filter,
        File(path),
        state.selectedSegmentIndex,
        state.showFilters,
        path));
  }

  void _onPostRecorderRecordingResumed(PostRecorderRecordingResumed event,
      Emitter<PostRecorderState> emit) async {
    final path = await _repository.tempRecordingPath;
    final duration = state.duration;
    emit(PostRecorderRecordingStartInProgress(
      [
        ...state.segments,
        RecordingSegmentModel([], duration, duration, File(path), state.filter)
      ],
      state.playbackStatus,
      RecordingStatus.recording,
      state.recordingPosition,
      state.playbackPosition,
      state.filter,
      state.recording,
      state.selectedSegmentIndex,
      state.showFilters,
      path,
    ));
  }

  void _onPostRecorderRecordingStopped(
      PostRecorderRecordingStopped event, Emitter<PostRecorderState> emit) {
    emit(PostRecorderRecordingStopInProgress(
      state.segments,
      state.playbackStatus,
      RecordingStatus.waiting,
      state.recordingPosition,
      Duration.zero,
      state.filter,
      state.recording,
      state.selectedSegmentIndex,
      state.showFilters,
    ));
  }

  void _onPostRecorderPlaybackStarted(
      PostRecorderPlaybackStarted event, Emitter<PostRecorderState> emit) {
    emit(PostRecorderPlaybackStartInProgress(
      state.segments,
      PlaybackStatus.playing,
      state.recordingStatus,
      state.recordingPosition,
      state.playbackPosition,
      state.filter,
      state.recording,
      state.selectedSegmentIndex,
      state.showFilters,
    ));
  }

  void _onPostRecorderPlaybackStopped(
      PostRecorderPlaybackStopped event, Emitter<PostRecorderState> emit) {
    emit(PostRecorderPlaybackStopInProgress(
      state.segments,
      PlaybackStatus.waiting,
      state.recordingStatus,
      state.recordingPosition,
      state.playbackPosition,
      state.filter,
      state.recording,
      state.selectedSegmentIndex,
      state.showFilters,
    ));
  }

  void _onPostRecorderSegmentAmpsChanged(
      PostRecorderSegmentAmpsChanged event, Emitter<PostRecorderState> emit) {
    emit(state.copyWith(segments: [
      ...state.segments.sublist(0, state.segments.length - 1),
      state.segments.last.copyWith(amps: event.amps)
    ]));
  }

  void _onPostRecorderRecordingDeleted(PostRecorderRecordingDeleted event,
      Emitter<PostRecorderState> emit) async {
    await _repository
        .deleteFiles([state.recording, ...state.segments.map((s) => s.file)]);
    emit(PostRecorderPlaybackStopInProgress(
      const [],
      PlaybackStatus.initial,
      RecordingStatus.initial,
      Duration.zero,
      Duration.zero,
      state.filter,
      null,
      -1,
      state.showFilters,
    ));
  }

  void _onPostRecorderSegmentDeleted(
      PostRecorderSegmentDeleted event, Emitter<PostRecorderState> emit) async {
    if (state.segments.length == 1) {
      await _repository
          .deleteFiles([state.segments.first.file, state.recording]);
      emit(PostRecorderInitial(
        const [],
        PlaybackStatus.initial,
        RecordingStatus.initial,
        Duration.zero,
        Duration.zero,
        state.filter,
        null,
        -1,
        state.showFilters,
      ));
    } else {
      final recording = await _repository.deleteSegment(
          state.segments, event.deletedIndex, state.recording);
      final newSegments = List<RecordingSegmentModel>.from(state.segments);
      if (event.deletedIndex < newSegments.length - 1) {
        // We need to update the start and end durations of each segment.
        final toRemove = newSegments[event.deletedIndex];
        for (int i = event.deletedIndex + 1; i < newSegments.length; i++) {
          final curr = newSegments[i];
          newSegments[i] = curr.copyWith(
              endPosition: curr.endPosition - toRemove.duration,
              startPosition: curr.startPosition - toRemove.duration);
        }
      }
      final removed = newSegments.removeAt(event.deletedIndex);
      await _repository.deleteFiles([removed.file, state.recording]);
      emit(PostRecorderPlaybackLoadInProgress(
        newSegments,
        PlaybackStatus.loading,
        state.recordingStatus,
        state.recordingPosition,
        state.playbackPosition,
        state.filter,
        recording,
        state.selectedSegmentIndex,
        state.showFilters,
        recording,
      ));
    }
  }

  void _onPostRecorderSegmentSelected(
      PostRecorderSegmentSelected event, Emitter<PostRecorderState> emit) {
    // emit(state.copyWith(selectedSegmentIndex: event.index));
  }

  void _onPostRecorderSegmentUnselected(
      PostRecorderSegmentUnselected event, Emitter<PostRecorderState> emit) {
    // emit(state.copyWith(selectedSegmentIndex: -1));
  }

  void _onPostRecorderSegmentFilterChanged(
      PostRecorderSegmentFilterChanged event,
      Emitter<PostRecorderState> emit) async {
    final updated = await _repository.replaceSegmentFilter(
        state.segments, event.segmentIndex, event.filter, state.recording);
    final newSegments = List<RecordingSegmentModel>.from(state.segments)
      ..[event.segmentIndex] =
          state.segments[event.segmentIndex].copyWith(filter: event.filter);
    await _repository.deleteFiles([state.recording]);
    emit(PostRecorderPlaybackLoadInProgress(
      newSegments,
      PlaybackStatus.loading,
      state.recordingStatus,
      state.recordingPosition,
      state.playbackPosition,
      state.filter,
      updated,
      state.selectedSegmentIndex,
      state.showFilters,
      updated,
    ));
  }

  void _onPostRecorderSegmentFileProcessed(
      PostRecorderSegmentFileProcessed event,
      Emitter<PostRecorderState> emit) async {
    final filteredFile =
        await _repository.applyFilter(state.filter, state.segments.last.file);
    if (state.segments.length != 1) {
      final concatFile =
          await _repository.concatDemux([state.recording, filteredFile]);
      if (state.segments.length > 2) {
        await _repository.deleteFiles([state.recording]);
      }
      emit(PostRecorderPlaybackLoadInProgress(
        state.segments,
        PlaybackStatus.loading,
        state.recordingStatus,
        state.recordingPosition,
        state.playbackPosition,
        state.filter,
        concatFile,
        state.selectedSegmentIndex,
        state.showFilters,
        concatFile,
      ));
    } else {
      emit(PostRecorderPlaybackLoadInProgress(
        state.segments,
        PlaybackStatus.loading,
        state.recordingStatus,
        state.recordingPosition,
        state.playbackPosition,
        state.filter,
        filteredFile,
        state.selectedSegmentIndex,
        state.showFilters,
        filteredFile,
      ));
    }
  }

  void _onPostRecorderPlaybackPositionChanged(
      PostRecorderPlaybackPositionChanged event,
      Emitter<PostRecorderState> emit) {
    emit(state.copyWith(playbackPosition: event.position));
  }

  void _onPostRecorderRecordingPositionChanged(
      PostRecorderRecordingPositionChanged event,
      Emitter<PostRecorderState> emit) {
    if (state.segments.length == 1) {
      emit(state.copyWith(recordingPosition: event.position, segments: [
        state.segments.first.copyWith(endPosition: event.position)
      ]));
    } else if (state.segments.length > 1) {
      emit(state.copyWith(recordingPosition: event.position, segments: [
        ...state.segments.sublist(0, state.segments.length - 1),
        state.segments.last.copyWith(
          endPosition: state.segments
                  .sublist(0, state.segments.length - 1)
                  .last
                  .endPosition +
              event.position,
        )
      ]));
    }
  }

  void _onPostRecorderPlaybackEnded(
      PostRecorderPlaybackEnded event, Emitter<PostRecorderState> emit) {
    emit(PostRecorderPlaybackEndInProgress(
      state.segments,
      PlaybackStatus.waiting,
      state.recordingStatus,
      state.recordingPosition,
      state.playbackPosition,
      state.filter,
      state.recording,
      state.selectedSegmentIndex,
      state.showFilters,
    ));
  }

  void _onPostRecorderEventFinished(
      PostRecorderEventFinished event, Emitter<PostRecorderState> emit) {
    emit(PostRecorderIdle(
      state.segments,
      state.playbackStatus,
      state.recordingStatus,
      state.recordingPosition,
      state.playbackPosition,
      state.filter,
      state.recording,
      state.selectedSegmentIndex,
      state.showFilters,
    ));
  }

  void _onPostRecorderFilterChanged(
      PostRecorderFilterChanged event, Emitter<PostRecorderState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onPostRecorderPlaybackSeekUpdated(
      PostRecorderPlaybackSeekUpdated event, Emitter<PostRecorderState> emit) {
    emit(state.copyWith(playbackPosition: event.position));
  }

  void _onPostRecorderPlaybackSeekFinished(
      PostRecorderPlaybackSeekFinished event, Emitter<PostRecorderState> emit) {
    emit(PostRecorderPlaybackSeekInProgress(
      state.segments,
      state.playbackStatus,
      state.recordingStatus,
      state.recordingPosition,
      state.playbackPosition,
      state.filter,
      state.recording,
      state.selectedSegmentIndex,
      state.showFilters,
      state.playbackPosition,
    ));
  }

  void _onPostRecorderFiltersShown(
      PostRecorderFiltersShown event, Emitter<PostRecorderState> emit) {
    emit(state.copyWith(showFilters: true));
  }

  void _onPostRecorderFiltersHidden(
      PostRecorderFiltersHidden event, Emitter<PostRecorderState> emit) {
    emit(state.copyWith(showFilters: false));
  }

  @override
  Future<void> close() async {
    await _repository.deleteFiles(state.segments.map((s) => s.file).toList());
    return super.close();
  }
}
