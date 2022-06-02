import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_event.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_state.dart';
import 'package:fun_recorder/constants/constants.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';
import 'package:fun_recorder/ui/components/post_recorder/record_button/message_room_recorder_page_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/src/provider.dart';

class RecordButtonPageView extends StatefulWidget {
  final PageController controller;
  final RecordingFilter activeFilter;
  final RecordingStatus recordingStatus;
  final Duration recordingDuration;
  final double height;

  const RecordButtonPageView(
      {Key key,
      this.controller,
      this.activeFilter,
      this.recordingStatus,
      this.recordingDuration,
      this.height})
      : super(key: key);

  @override
  State<RecordButtonPageView> createState() => _RecordButtonPageViewState();
}

class _RecordButtonPageViewState extends State<RecordButtonPageView> {
  Future<void> permissionAlertDialog(String title, String description) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(description),
                actions: [
                  CupertinoDialogAction(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Settings"),
                    onPressed: () async {
                      Navigator.pop(context);
                      await AppSettings.openAppSettings();
                    },
                  )
                ]));
  }

  Future<void> _onTapButton() async {
    if (await Permission.microphone.request().isGranted) {
      if (widget.recordingStatus == RecordingStatus.recording) {
        context.read<PostRecorderBloc>().add(PostRecorderRecordingStopped());
      } else if (widget.recordingStatus == RecordingStatus.initial) {
        context.read<PostRecorderBloc>().add(PostRecorderRecordingStarted());
      } else if (widget.recordingStatus == RecordingStatus.waiting) {
        context.read<PostRecorderBloc>().add(PostRecorderRecordingResumed());
      }
    } else {
      permissionAlertDialog("Enable Microphophone",
          "Enabling the microphone allows you to record posts and replies.");
    }
  }

  void alertDialogHandler(String title) async {
    showCupertinoDialog(
        context: context,
        builder: (context) =>
            CupertinoAlertDialog(title: Text(title), actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ]));
  }

  void _onLongPressButton() {
    if (widget.recordingStatus == RecordingStatus.initial) {
      context.read<PostRecorderBloc>().add(PostRecorderRecordingStarted());
    } else if (widget.recordingStatus == RecordingStatus.waiting) {
      context.read<PostRecorderBloc>().add(PostRecorderRecordingResumed());
    }
  }

  void _onLongPressEnd() {
    context.read<PostRecorderBloc>().add(PostRecorderRecordingStopped());
  }

  void _onTapInactiveButton(int index) {
    widget.controller.animateToPage(index,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  RecordingFilter _getFilter(int index) {
    switch (index) {
      case robotRecorderIndex:
        return RecordingFilter.robot;
      case highPitchRecorderIndex:
        return RecordingFilter.high;
      case lowPitchRecorderIndex:
        return RecordingFilter.low;
      case echoRecorderIndex:
        return RecordingFilter.echo;
      case wobbleRecorderIndex:
        return RecordingFilter.wobble;
      case reverseRecorderIndex:
        return RecordingFilter.reverse;
      case loudRecorderIndex:
        return RecordingFilter.loud;
      case defaultRecorderIndex:
      default:
        return RecordingFilter.normal;
    }
  }

  int _getFilterIndex(RecordingFilter filter) {
    switch (filter) {
      case RecordingFilter.robot:
        return robotRecorderIndex;
      case RecordingFilter.high:
        return highPitchRecorderIndex;
      case RecordingFilter.low:
        return lowPitchRecorderIndex;
      case RecordingFilter.echo:
        return echoRecorderIndex;
      case RecordingFilter.wobble:
        return wobbleRecorderIndex;
      case RecordingFilter.reverse:
        return reverseRecorderIndex;
      case RecordingFilter.loud:
        return loudRecorderIndex;
      case RecordingFilter.normal:
      default:
        return defaultRecorderIndex;
    }
  }

  int _getDistance(RecordingFilter activeFilter, int index) {
    final activeIndex = _getFilterIndex(activeFilter);
    return (index - activeIndex).abs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      child: MessageRoomRecorderPageView(
          onFilterChanged: (f) {
            context.read<PostRecorderBloc>().add(PostRecorderFilterChanged(f));
            HapticFeedback.lightImpact();
          },
          onLongPressButton: (f) {
            _onLongPressButton();
          },
          onLongPressButtonEnd: (f) {
            _onLongPressEnd();
          },
          onTapActiveButton: (f) {
            _onTapButton();
          },
          activeFilter: widget.activeFilter,
          buttonSize: 72,
          iconSize: 48,
          isRecording: widget.recordingStatus == RecordingStatus.recording,
          controller: widget.controller),
    );
  }
}
