import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_event.dart';
import 'package:fun_recorder/blocs/post_recorder_bloc/post_recorder_state.dart';
import 'package:fun_recorder/blocs/scale_bloc/scale_bloc.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_segment.dart';

import '../../../blocs/post_recorder_bloc/post_recorder_bloc.dart';
import '../../../models/recording_segment_model.dart';

class PostRecorderPlaybackStage extends StatefulWidget {
  final List<RecordingSegmentModel> segments;
  final int selectedSegmentIndex;
  final Duration playbackPosition;
  final bool playbackInProgress;

  const PostRecorderPlaybackStage(
      {Key key,
      this.segments,
      this.selectedSegmentIndex,
      this.playbackPosition,
      this.playbackInProgress})
      : super(key: key);

  @override
  State<PostRecorderPlaybackStage> createState() =>
      _PostRecorderPlaybackStageState();
}

class _PostRecorderPlaybackStageState extends State<PostRecorderPlaybackStage> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScaleBloc>(
            create: (_) => ScaleBloc(MediaQuery.of(context).size.width /
                widget.segments.last.endPosition.inMilliseconds)),
      ],
      child: BlocBuilder<ScaleBloc, ScaleState>(builder: (context, state) {
        return BlocListener<PostRecorderBloc, PostRecorderState>(
          listenWhen: (old, recorderState) =>
              recorderState.segments.length > 0 &&
              recorderState.segments.length < old.segments.length,
          listener: (context, recorderState) {
            // In case a segment is deleted, we need to make sure remaining
            // segments fill horizontal width.
            if (state.scaleFactor *
                    recorderState.segments.last.endPosition.inMilliseconds <
                MediaQuery.of(context).size.width) {
              context.read<ScaleBloc>().add(ScaleFactorChanged(
                  MediaQuery.of(context).size.width /
                      recorderState.segments.last.endPosition.inMilliseconds));
            }
          },
          child: GestureDetector(
            onLongPressMoveUpdate: widget.playbackInProgress
                ? null
                : (det) {
                    context.read<PostRecorderBloc>().add(
                        PostRecorderPlaybackSeekUpdated(Duration(
                            milliseconds:
                                (det.localPosition.dx + _controller.offset) ~/
                                    state.scaleFactor)));
                  },
            onLongPress: () {
              if (widget.playbackInProgress) {
                context
                    .read<PostRecorderBloc>()
                    .add(PostRecorderPlaybackStopped());
              }
              HapticFeedback.mediumImpact();
            },
            onLongPressEnd: widget.playbackInProgress
                ? null
                : (_) => context
                    .read<PostRecorderBloc>()
                    .add(PostRecorderPlaybackSeekFinished()),
            onLongPressCancel: widget.playbackInProgress
                ? null
                : () => context
                    .read<PostRecorderBloc>()
                    .add(PostRecorderPlaybackSeekFinished()),
            behavior: HitTestBehavior.opaque,
            onScaleStart: (det) => context
                .read<ScaleBloc>()
                .add(ScaleBaseFactorChanged(state.scaleFactor)),
            onScaleUpdate: (det) {
              if (det.scale == 1.0) {
                return;
              }
              context.read<ScaleBloc>().add(ScaleFactorChanged(
                  (state.baseFactor * det.scale).clamp(
                      MediaQuery.of(context).size.width /
                          widget.segments.last.endPosition.inMilliseconds,
                      5.0 *
                          MediaQuery.of(context).size.width /
                          widget.segments.last.endPosition.inMilliseconds)));
            },
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.segments.length,
              itemBuilder: (context, index) {
                final segment = widget.segments[index];
                return Container(
                    margin: EdgeInsets.only(right: 1),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PostRecorderSegment(
                            segment: segment,
                            onDelete: () => context
                                .read<PostRecorderBloc>()
                                .add(PostRecorderSegmentDeleted(index)),
                            onChangeFilter: (filter) => context
                                .read<PostRecorderBloc>()
                                .add(PostRecorderSegmentFilterChanged(
                                    index, filter)),
                            width: state.scaleFactor *
                                segment.duration.inMilliseconds.toDouble()
                            // /segments.last.duration.inMicroseconds,
                            ),
                        if (widget.playbackPosition > segment.startPosition &&
                            widget.playbackPosition < segment.endPosition)
                          BlocBuilder<PostRecorderBloc, PostRecorderState>(
                              buildWhen: (old, state) =>
                                  old.playbackPosition !=
                                  state.playbackPosition,
                              builder: (context, recorderState) {
                                return Positioned(
                                  left: state.scaleFactor *
                                      (recorderState
                                              .playbackPosition.inMilliseconds
                                              .toDouble() -
                                          segment.startPosition.inMilliseconds
                                              .toDouble()),
                                  child: Container(
                                    width: 2,
                                    height: 150,
                                    color: CupertinoColors.white,
                                  ),
                                );
                              }),
                      ],
                    ));
              },
            ),
          ),
        );
      }),
    );
  }
}
