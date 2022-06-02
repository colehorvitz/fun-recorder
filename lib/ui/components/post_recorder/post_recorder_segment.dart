import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/blocs/simple_boolean_cubit/simple_boolean_cubit.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';
import 'package:fun_recorder/models/recording_segment_model.dart';
import 'package:fun_recorder/services/hex_color.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_filter_selection_list.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_segment_options.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PostRecorderSegment extends StatefulWidget {
  final RecordingSegmentModel segment;
  final double width;
  final VoidCallback onDelete;
  final Function(RecordingFilter) onChangeFilter;

  const PostRecorderSegment(
      {Key key, this.segment, this.width, this.onDelete, this.onChangeFilter})
      : super(key: key);

  @override
  State<PostRecorderSegment> createState() => _PostRecorderSegmentState();
}

class _PostRecorderSegmentState extends State<PostRecorderSegment> {
  Color get color {
    switch (widget.segment.filter) {
      case RecordingFilter.robot:
        return HexColor('5F5FFF');
      case RecordingFilter.high:
        return HexColor('52D885');
      case RecordingFilter.low:
        return HexColor('FF9A19');
      case RecordingFilter.echo:
        return HexColor('BB48EB');
      case RecordingFilter.wobble:
        return HexColor('8BCB27');
      case RecordingFilter.reverse:
        return HexColor('F56780');
      case RecordingFilter.loud:
        return HexColor('2FC6F8');
      case RecordingFilter.normal:
      default:
        return HexColor('FF4545');
    }
  }

  Future<void> _onTap() async {
    final result = await showCupertinoModalBottomSheet(
        context: context,
        bounce: false,
        topRadius: Radius.circular(10),
        useRootNavigator: true,
        builder: (context) =>
            PostRecorderSegmentOptions(segment: widget.segment));
    switch (result) {
      case ("delete"):
        _onDeleteClip();
        break;
      case ("change-filter"):
        _onChangeFilter();
        break;
    }
  }

  Future<void> _onDeleteClip() async {
    final confirm = await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
                title: Text("Are you sure you want to delete this clip?"),
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
      widget.onDelete();
    }
  }

  Future<void> _onChangeFilter() async {
    final result = await showCupertinoModalBottomSheet(
        context: context,
        bounce: false,
        topRadius: Radius.circular(10),
        useRootNavigator: true,
        builder: (context) => PostRecorderFilterSelectionList(
            selectedFilter: widget.segment.filter));
    if (result is RecordingFilter && result != widget.segment.filter) {
      widget.onChangeFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleBooleanCubit>(
      create: (_) => SimpleBooleanCubit(false),
      child: BlocBuilder<SimpleBooleanCubit, bool>(builder: (context, pressed) {
        return GestureDetector(
          onTapDown: (_) => context.read<SimpleBooleanCubit>().setTrue(),
          onLongPress: () {
            context.read<SimpleBooleanCubit>().setFalse();
            _onTap();
          },
          onTapUp: (_) async {
            context.read<SimpleBooleanCubit>().setFalse();
            _onTap();
          },
          onTapCancel: () => context.read<SimpleBooleanCubit>().setFalse(),
          child: Opacity(
            opacity: pressed ? 0.5 : 1,
            child: Container(
              width: widget.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: widget.width,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                    ),
                    child: Text(
                      widget.segment.filter == RecordingFilter.high
                          ? "High-Pitch"
                          : widget.segment.filter == RecordingFilter.low
                              ? "Low-Pitch"
                              : widget.segment.filter == RecordingFilter.robot
                                  ? "Robot"
                                  : widget.segment.filter ==
                                          RecordingFilter.echo
                                      ? "Echo"
                                      : widget.segment.filter ==
                                              RecordingFilter.wobble
                                          ? "Wobble"
                                          : widget.segment.filter ==
                                                  RecordingFilter.reverse
                                              ? "Reverse"
                                              : widget.segment.filter ==
                                                      RecordingFilter.loud
                                                  ? "Loud"
                                                  : "Normal",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(color: CupertinoColors.white, fontSize: 14),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: widget.width,
                    decoration: BoxDecoration(
                      color: color.withOpacity(.5),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: CustomPaint(
                      size: Size(widget.width, 100),
                      painter: WaveformPainter(
                        widget.segment.amps,
                        CupertinoColors.white.withOpacity(.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amps;
  final Color color;

  const WaveformPainter(this.amps, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    Path path = Path();
    final posPoints = <Offset>[];
    final negPoints = <Offset>[];
    final length = amps.length;
    final split = length < 100 ? length : length ~/ 100;
    final averages = <double>[];
    for (int i = 0; i < amps.length; i += split) {
      final sublist = amps.sublist(i, min(i + split, amps.length));
      final avg = sublist.reduce((prev, curr) => prev + curr) /
          min(split, sublist.length);
      averages.add(avg);
    }
    for (int i = 0; i < averages.length; i++) {
      posPoints.add(Offset(
          i == averages.length - 1
              ? size.width
              : size.width / averages.length * i,
          size.height / 2 - (50 * averages[i])));
    }
    for (int i = 0; i < averages.length; i++) {
      negPoints.add(Offset(
          i == averages.length - 1
              ? 0
              : size.width - size.width / averages.length * i,
          size.height / 2 + (50 * averages.reversed.toList()[i])));
    }
    path.moveTo(0, size.height / 2);
    posPoints.forEach((pt) => path.lineTo(pt.dx, pt.dy));
    negPoints.forEach((pt) => path.lineTo(pt.dx, pt.dy));

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) => false;
}
