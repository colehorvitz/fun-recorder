import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../../../services/hex_color.dart';
import 'record_button.dart';

class RobotRecordButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onTapWhileDisabled;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressEnd;
  final bool selected;
  final bool recording;
  final int distance;
  final double size;
  final double iconSize;

  const RobotRecordButton({
    Key key,
    this.onTap,
    this.selected,
    this.recording,
    this.distance,
    this.onTapWhileDisabled,
    this.onLongPress,
    this.onLongPressEnd,
    this.size,
    this.iconSize = 48,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RecordButton(
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      onTap: onTap,
      selected: selected,
      recording: recording,
      child: Icon(
        MaterialCommunityIcons.robot,
        color: CupertinoColors.white,
        size: iconSize,
      ),
      size: size,
      onTapWhileDisabled: onTapWhileDisabled,
      distance: distance,
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HexColor('29B2FF'), HexColor('940CFF')]),
    );
  }
}
