import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../../models/recording_filter_model.dart';
import '../selections/selection.dart';
import '../selections/selections.dart';

class PostRecorderFilterSelectionList extends StatelessWidget {
  final RecordingFilter selectedFilter;

  const PostRecorderFilterSelectionList({
    Key key,
    this.selectedFilter,
  }) : super(key: key);

  IconData icon(RecordingFilter filter) {
    switch (filter) {
      case RecordingFilter.robot:
        return MaterialCommunityIcons.robot;
      case RecordingFilter.high:
        return MaterialCommunityIcons.waveform;
      case (RecordingFilter.low):
        return MaterialCommunityIcons.wave;
      case (RecordingFilter.echo):
        return CupertinoIcons.home;
      case (RecordingFilter.echo):
        return CupertinoIcons.antenna_radiowaves_left_right;
      case RecordingFilter.wobble:
        return MaterialCommunityIcons.sine_wave;
      case RecordingFilter.reverse:
        return Foundation.refresh;
      case RecordingFilter.loud:
        return FontAwesome.bomb;
      default:
        return CupertinoIcons.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selections(
      title: "Select Filter",
      selections: [
        Selection(
          title: "Normal",
          iconData: CupertinoIcons.home,
          isSelected: selectedFilter == RecordingFilter.normal,
          onTap: () => Navigator.of(context).pop(RecordingFilter.normal),
        ),
        Selection(
          title: "Robot",
          iconData: MaterialCommunityIcons.robot,
          isSelected: selectedFilter == RecordingFilter.robot,
          onTap: () => Navigator.of(context).pop(RecordingFilter.robot),
        ),
        Selection(
          title: "High-Pitch",
          iconData: MaterialCommunityIcons.waveform,
          isSelected: selectedFilter == RecordingFilter.high,
          onTap: () => Navigator.of(context).pop(RecordingFilter.high),
        ),
        Selection(
          title: "Low-Pitch",
          iconData: MaterialCommunityIcons.wave,
          isSelected: selectedFilter == RecordingFilter.low,
          onTap: () => Navigator.of(context).pop(RecordingFilter.low),
        ),
        Selection(
          title: "Echo",
          iconData: CupertinoIcons.antenna_radiowaves_left_right,
          isSelected: selectedFilter == RecordingFilter.echo,
          onTap: () => Navigator.of(context).pop(RecordingFilter.echo),
        ),
        Selection(
          title: "Wobble",
          iconData: MaterialCommunityIcons.sine_wave,
          isSelected: selectedFilter == RecordingFilter.wobble,
          onTap: () => Navigator.of(context).pop(RecordingFilter.wobble),
        ),
        Selection(
          title: "Reverse",
          iconData: Foundation.refresh,
          isSelected: selectedFilter == RecordingFilter.reverse,
          onTap: () => Navigator.of(context).pop(RecordingFilter.reverse),
        ),
        Selection(
          title: "Loud",
          iconData: FontAwesome.bomb,
          isSelected: selectedFilter == RecordingFilter.loud,
          onTap: () => Navigator.of(context).pop(RecordingFilter.loud),
        ),
      ],
    );
  }
}
