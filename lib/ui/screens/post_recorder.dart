import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_event.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_state.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_bottom_bar.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_default_controls.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_initial_stage.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_playback_stage.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_stage.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_timer.dart';
import 'package:fun_recorder/ui/components/post_recorder/record_button/record_button_target.dart';
import 'package:fun_recorder/ui/components/post_recorder/record_button_page_view.dart';
import 'package:fun_recorder/ui/components/responsive_buttons/responsive_tap_icon.dart';
import 'package:fun_recorder/ui/components/responsive_buttons/responsive_tap_text.dart';
import 'package:fun_recorder/ui/wrappers/post_recorder_wrapper.dart';

class PostRecorder extends StatefulWidget {
  const PostRecorder({Key key}) : super(key: key);

  @override
  State<PostRecorder> createState() => _PostRecorderState();
}

class _PostRecorderState extends State<PostRecorder> {
  final _recordButtonController = PageController(viewportFraction: .25);
  final _recorderStageController = ScrollController();

  @override
  void dispose() {
    _recordButtonController.dispose();
    _recorderStageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PostRecorderWrapper(
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // border: null,
          leading: BlocBuilder<PostRecorderBloc, PostRecorderState>(
              buildWhen: (old, state) =>
                  old is PostRecorderInitial || state is PostRecorderInitial,
              builder: (context, state) {
                if (state is PostRecorderInitial) {
                  return ResponsiveTapIcon(
                    iconData: CupertinoIcons.gear,
                    activeColor: CupertinoColors.black.withOpacity(.5),
                    defaultColor: CupertinoColors.black,
                    size: 24,
                    onTap: () {},
                  );
                }
                return ResponsiveTapIcon(
                  iconData: CupertinoIcons.xmark,
                  activeColor: CupertinoColors.black.withOpacity(.5),
                  defaultColor: CupertinoColors.black,
                  size: 24,
                  onTap: () {},
                );
              }),
          trailing: ResponsiveTapText(
            "Save",
            defaultStyle: TextStyle(
              color: CupertinoColors.black,
            ),
            pressedStyle: TextStyle(
              color: CupertinoColors.black.withOpacity(.5),
            ),
            onTap: () {},
          ),
          transitionBetweenRoutes: false,
          middle: BlocBuilder<PostRecorderBloc, PostRecorderState>(
            builder: (context, state) => state is PostRecorderInitial
                ? Text("Record")
                : PostRecorderTimer(
                    duration: state.recordingStatus == RecordingStatus.recording
                        ? Duration(
                            milliseconds:
                                state.segments.last.endPosition.inMilliseconds,
                          )
                        : state.playbackPosition),
          ),
        ),
        child: SafeArea(
            child: Center(
                child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            BlocBuilder<PostRecorderBloc, PostRecorderState>(
                buildWhen: (old, state) =>
                    old.recordingStatus != state.recordingStatus,
                builder: (context, state) {
                  return state.recordingStatus == RecordingStatus.initial
                      ? PostRecorderInitialStage()
                      : state.recordingStatus == RecordingStatus.recording
                          ? BlocBuilder<PostRecorderBloc, PostRecorderState>(
                              buildWhen: (old, state) =>
                                  old.segments != state.segments ||
                                  old.filter != state.filter,
                              builder: (context, state) {
                                return PostRecorderStage(
                                  segments: state.segments,
                                  controller: _recorderStageController,
                                  filter: state.filter,
                                );
                              })
                          : BlocBuilder<PostRecorderBloc, PostRecorderState>(
                              buildWhen: (old, state) =>
                                  old.segments != state.segments ||
                                  old.selectedSegmentIndex !=
                                      state.selectedSegmentIndex ||
                                  old.playbackPosition !=
                                      state.playbackPosition,
                              builder: (context, state) {
                                return PostRecorderPlaybackStage(
                                  playbackInProgress: state.playbackStatus ==
                                      PlaybackStatus.playing,
                                  segments: state.segments,
                                  playbackPosition: state.playbackPosition,
                                  selectedSegmentIndex:
                                      state.selectedSegmentIndex,
                                );
                              });
                }),
            BlocBuilder<PostRecorderBloc, PostRecorderState>(
                buildWhen: (old, state) =>
                    old.recordingStatus != state.recordingStatus,
                builder: (context, state) {
                  return Positioned(
                      bottom: 63,
                      child: RecordButtonTarget(
                        recording:
                            state.recordingStatus == RecordingStatus.recording,
                      ));
                }),
            BlocBuilder<PostRecorderBloc, PostRecorderState>(
                buildWhen: (old, state) =>
                    old.duration != state.duration ||
                    old.recordingStatus != state.recordingStatus ||
                    old.filter != state.filter ||
                    old.showFilters != state.showFilters,
                builder: (context, state) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: 72,
                    child: state.showFilters
                        ? RecordButtonPageView(
                            recordingDuration: state.duration,
                            controller: _recordButtonController,
                            activeFilter: state.filter,
                            recordingStatus: state.recordingStatus,
                          )
                        : PostRecorderDefaultControls(
                            recordingStatus: state.recordingStatus,
                            recordingDuration: state.duration,
                          ),
                  );
                }),
            BlocBuilder<PostRecorderBloc, PostRecorderState>(
                buildWhen: (old, state) =>
                    old.recordingStatus != state.recordingStatus ||
                    old.playbackStatus != state.playbackStatus ||
                    old.filter != state.filter ||
                    old.showFilters != state.showFilters,
                builder: (context, state) {
                  if (state.showFilters) {
                    return Positioned(
                        left: 0,
                        right: 0,
                        bottom: 24,
                        child: Center(
                          child: ResponsiveTapIcon(
                            iconData: CupertinoIcons.xmark_circle_fill,
                            activeColor: CupertinoColors.systemGrey5,
                            defaultColor: CupertinoColors.systemGrey2,
                            onTap: () {
                              context
                                  .read<PostRecorderBloc>()
                                  .add(PostRecorderFiltersHidden());
                            },
                          ),
                        ));

                    // Padding(
                    //     padding:
                    //         const EdgeInsets.symmetric(horizontal: 24.0),
                    //     child: PostRecorderBottomBar(
                    //         recordingStatus: state.recordingStatus,
                    //         playbackStatus: state.p
                    //         filter: state.filter))
                    //         )

                    //         ;
                  }
                  return Container();
                }),
          ],
        ))),
      ),
    );
  }
}
