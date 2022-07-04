import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_event.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_state.dart';
import 'package:fun_recorder/ui/components/post_recorder/record_button/default_record_button.dart';
import 'package:fun_recorder/ui/components/responsive_buttons/responsive_tap_icon.dart';
import 'package:permission_handler/permission_handler.dart';

class PostRecorderDefaultControls extends StatefulWidget {
  final RecordingStatus recordingStatus;
  final Duration recordingDuration;

  const PostRecorderDefaultControls(
      {Key key, this.recordingStatus, this.recordingDuration})
      : super(key: key);

  @override
  State<PostRecorderDefaultControls> createState() =>
      _PostRecorderDefaultControlsState();
}

class _PostRecorderDefaultControlsState
    extends State<PostRecorderDefaultControls> {
  void _onLongPressButton() {
    if (widget.recordingStatus == RecordingStatus.initial) {
      context.read<PostRecorderBloc>().add(PostRecorderRecordingStarted());
    } else if (widget.recordingStatus == RecordingStatus.waiting) {
      context.read<PostRecorderBloc>().add(PostRecorderRecordingResumed());
    }
  }

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

  void _onLongPressEnd() {
    context.read<PostRecorderBloc>().add(PostRecorderRecordingStopped());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ResponsiveTapIcon(
          iconData: CupertinoIcons.music_note_2,
          size: 32,
          onTap: () {},
          defaultColor: CupertinoColors.activeBlue,
          activeColor: CupertinoColors.activeBlue.withOpacity(.7),
        ),
        SizedBox(
          width: 32,
        ),
        DefaultRecordButton(
          size: 72,
          onTap: _onTapButton,
          onLongPress: _onLongPressButton,
          onLongPressEnd: _onLongPressEnd,
          distance: 0,
          onTapWhileDisabled: null,
          recording: widget.recordingStatus == RecordingStatus.recording,
          selected: true,
        ),
        SizedBox(
          width: 32,
        ),
        ResponsiveTapIcon(
          iconData: CupertinoIcons.smiley,
          size: 32,
          onTap: () {
            context.read<PostRecorderBloc>().add(PostRecorderFiltersShown());
          },
          defaultColor: CupertinoColors.activeBlue,
          activeColor: CupertinoColors.activeBlue.withOpacity(.7),
        ),
      ],
    );
  }
}
