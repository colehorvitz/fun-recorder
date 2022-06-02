import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:fun_recorder/blocs/audio_file_upload_bloc/file_upload_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_event.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_state.dart';
import 'package:fun_recorder/data/audio_file_upload_repository.dart';
import 'package:fun_recorder/data/post_recorder_repository.dart';
import 'package:fun_recorder/services/audio_processor.dart';
import 'package:fun_recorder/services/audio_recorder.dart';
import 'package:just_audio/just_audio.dart';

class PostRecorderWrapper extends StatefulWidget {
  final Widget child;

  const PostRecorderWrapper({Key key, this.child}) : super(key: key);

  @override
  State<PostRecorderWrapper> createState() => _PostRecorderWrapperState();
}

class _PostRecorderWrapperState extends State<PostRecorderWrapper> {
  PostRecorderBloc _postRecorderBloc;
  AudioFileUploadBloc _audioFileUploadBloc;

  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    _audioPlayer.positionStream.listen((position) {
      if (position != null)
        _postRecorderBloc.add(PostRecorderPlaybackPositionChanged(position));
    });
    _audioPlayer.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        _postRecorderBloc.add(PostRecorderPlaybackEnded());
      }
    });
    _audioRecorder.recordingDataStream.listen((data) {
      _postRecorderBloc
          .add(PostRecorderRecordingPositionChanged(data.duration));
      _postRecorderBloc.add(PostRecorderSegmentAmpsChanged(data.amps));
    });
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.tearDown();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostRecorderBloc>(
            create: (context) => _postRecorderBloc = PostRecorderBloc(
                RecorderRepository(AudioProcessor(FlutterFFmpeg())))),
        BlocProvider<AudioFileUploadBloc>(
            create: (context) => _audioFileUploadBloc =
                AudioFileUploadBloc(AudioFileUploadRepository())),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderRecordingStartInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) {
              if (state is PostRecorderRecordingStartInProgress) {
                _audioPlayer.pause();
                _audioRecorder.startRecording(state.path);
              }
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderRecordingStopInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) async {
              final file = await _audioRecorder.stopRecording();
              _postRecorderBloc.add(PostRecorderSegmentFileProcessed(file));
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderPlaybackLoadInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) async {
              if (state is PostRecorderPlaybackLoadInProgress) {
                await _audioPlayer.pause();
                _audioPlayer.setFilePath(state.loadedFile.path);
                // _postRecorderBloc.add(PostRecorderPlaybackStarted());
              }
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderPlaybackStartInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) {
              _audioPlayer.play();
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderPlaybackEndInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) async {
              _audioPlayer.pause();
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderPlaybackEndInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) async {
              await _audioPlayer.pause();
              _audioPlayer.seek(Duration.zero);
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderPlaybackStopInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) async {
              _audioPlayer.pause();
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
          BlocListener<PostRecorderBloc, PostRecorderState>(
            listenWhen: (_, state) =>
                state is PostRecorderPlaybackSeekInProgress,
            bloc: _postRecorderBloc,
            listener: (context, state) async {
              if (state is PostRecorderPlaybackSeekInProgress) {
                _audioPlayer.seek(state.position);
              }
              _postRecorderBloc.add(PostRecorderEventFinished());
            },
          ),
        ],
        child: widget.child,
      ),
    );
  }
}
