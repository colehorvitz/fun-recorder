import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum RecordingFilter { normal, high, low, robot, echo, wobble, reverse, loud }

class RecordingFilterModel extends Equatable {
  final Color gradientStop1;
  final Color gradientStop2;
  final Color lineColor;
  final IconData iconData;

  const RecordingFilterModel(
      this.gradientStop1, this.gradientStop2, this.lineColor,
      [this.iconData]);

  @override
  List<Object> get props => [gradientStop1, gradientStop2, lineColor, iconData];
}
