import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fun_recorder/constants/constants.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_filter_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../blocs/audio_file_upload_bloc/file_upload_bloc.dart';
import '../../../blocs/audio_file_upload_bloc/file_upload_event.dart';
import '../../../blocs/post_recorder_bloc/post_recorder_bloc.dart';
import '../../../blocs/post_recorder_bloc/post_recorder_event.dart';
import '../../../blocs/post_recorder_bloc/post_recorder_state.dart';
import '../../../models/recording_filter_model.dart';
import '../responsive_buttons/responsive_tap_icon.dart';

class PostRecorderBottomBar extends StatefulWidget {
  final RecordingFilter filter;
  final RecordingStatus recordingStatus;
  final PlaybackStatus playbackStatus;

  const PostRecorderBottomBar(
      {Key key, this.filter, this.recordingStatus, this.playbackStatus})
      : super(key: key);

  @override
  State<PostRecorderBottomBar> createState() => _PostRecorderBottomBarState();
}

class _PostRecorderBottomBarState extends State<PostRecorderBottomBar> {
  Future<void> _permissionAlertDialog(String title, String content) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
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

  Future<void> _deletionHandler() async {
    final confirm = await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
                title: Text("Are you sure you want to delete this recording?"),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("Delete"),
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ]));
    if (confirm) {
      context.read<PostRecorderBloc>().add(PostRecorderRecordingDeleted());
    }
  }

  Future<void> _uploadHandler() async {
    final choice = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        title: Text('Upload Audio'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Audio File'),
            onPressed: () {
              Navigator.of(context).pop("files");
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Audio From Video'),
            onPressed: () {
              Navigator.of(context).pop("videos");
            },
          ),
        ],
      ),
    );
    switch (choice) {
      case "files":
        if (await Permission.storage.request().isGranted) {
          final result = await FilePicker.platform
              .pickFiles(type: FileType.custom, allowedExtensions: extList);
          if (result != null) {
            final file = File(result.files.first.path);
            context
                .read<AudioFileUploadBloc>()
                .add(AudioFileUploaded(file.path));
          }
        } else {
          _permissionAlertDialog(
              "Please enable file permissions in Settings in order to upload a file.",
              "Enabling this permision allows you to upload audio files for your recordings.");
        }
        break;
      case "videos":
        if (Platform.isAndroid
            ? await Permission.storage.request().isGranted
            : await Permission.photos.request().isGranted) {
          final picker = ImagePicker();
          XFile video = await picker.pickVideo(source: ImageSource.gallery);
          if (video != null) {
            final file = File(video.path);
            context
                .read<AudioFileUploadBloc>()
                .add(AudioFileUploaded(file.path));
          }
        } else {
          _permissionAlertDialog(
              "Please enable ${Platform.isAndroid ? 'file' : 'photo'} permissions in Settings in order to upload audio.",
              "Enabling this permision allows you to upload ${Platform.isAndroid ? 'audio files' : 'video audio'} for your recordings.");
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ResponsiveTapIcon(
        //     iconData: CupertinoIcons.trash,
        //     activeColor: CupertinoColors.black.withOpacity(.5),
        //     defaultColor: CupertinoColors.black,
        //     size: 24,
        //     onTap: (widget.playbackStatus == PlaybackStatus.initial &&
        //                 widget.recordingStatus == RecordingStatus.initial) ||
        //             widget.recordingStatus == RecordingStatus.recording
        //         ? null
        //         : _deletionHandler),

        PostRecorderFilterText(
          filter: widget.filter,
        ),
        // ResponsiveTapIcon(
        //     iconData: widget.playbackStatus == PlaybackStatus.initial &&
        //             widget.recordingStatus == RecordingStatus.initial
        //         ? MaterialIcons.file_upload
        //         : widget.playbackStatus == PlaybackStatus.playing
        //             ? CupertinoIcons.pause_fill
        //             : CupertinoIcons.play_fill,
        //     activeColor: CupertinoColors.black.withOpacity(.5),
        //     defaultColor: CupertinoColors.black,
        //     size: 24,
        //     onTap: widget.playbackStatus == PlaybackStatus.initial &&
        //             widget.recordingStatus == RecordingStatus.initial
        //         ? _uploadHandler
        //         : widget.recordingStatus == RecordingStatus.recording
        //             ? null
        //             : () {
        //                 context.read<PostRecorderBloc>().add(
        //                     widget.playbackStatus == PlaybackStatus.playing
        //                         ? PostRecorderPlaybackStopped()
        //                         : PostRecorderPlaybackStarted());
        //               }),
      ],
    );
  }
}
