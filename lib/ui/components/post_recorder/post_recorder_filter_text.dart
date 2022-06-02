import 'package:flutter/cupertino.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';

class PostRecorderFilterText extends StatelessWidget {
  final RecordingFilter filter;

  const PostRecorderFilterText({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      filter == RecordingFilter.high
          ? "High-Pitch".toUpperCase()
          : filter == RecordingFilter.low
              ? "Low-Pitch".toUpperCase()
              : filter == RecordingFilter.robot
                  ? "Robot".toUpperCase()
                  : filter == RecordingFilter.echo
                      ? "Echo".toUpperCase()
                      : filter == RecordingFilter.wobble
                          ? "Wobble".toUpperCase()
                          : filter == RecordingFilter.reverse
                              ? "Reverse".toUpperCase()
                              : filter == RecordingFilter.loud
                                  ? "Loud".toUpperCase()
                                  : "Normal".toUpperCase(),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
