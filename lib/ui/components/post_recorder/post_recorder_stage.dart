import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';
import 'package:fun_recorder/models/recording_segment_model.dart';
import 'package:fun_recorder/services/hex_color.dart';
import 'package:fun_recorder/ui/components/post_recorder/post_recorder_amp.dart';

class PostRecorderStage extends StatelessWidget {
  final List<RecordingSegmentModel> segments;
  final ScrollController controller;
  final RecordingFilter filter;

  List<double> get amps =>
      segments.fold([], (prev, curr) => [...prev, ...curr.amps]);

  const PostRecorderStage(
      {Key key, this.segments, this.controller, this.filter})
      : super(key: key);

  List<Widget> get _ampWidgets {
    final widgets = <Widget>[];
    for (final segment in segments) {
      final amps = _reducedAmps(segment);
      final color = _getColor(segment.filter);
      widgets.addAll(
          amps.map((amp) => PostRecorderAmp(color: color, amp: amp)).toList());
    }
    return widgets;
  }

  List<double> _reducedAmps(RecordingSegmentModel segment) {
    final reducedAmps = <double>[];
    final int modulus = 4;
    final ampsCopy = segment.amps;
    for (int i = 0; i < ampsCopy.length; i++) {
      if (i % modulus == 0) {
        reducedAmps.add(ampsCopy[i]);
      }
    }
    return reducedAmps.sublist(
        max(0, reducedAmps.length - 1000), reducedAmps.length);
  }

  Color _getColor(RecordingFilter filter) {
    switch (filter) {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      physics: NeverScrollableScrollPhysics(),
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _ampWidgets,
      ),
    );
  }
}
