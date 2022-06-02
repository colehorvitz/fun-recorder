import 'package:flutter/cupertino.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:fun_recorder/services/hex_color.dart';

import 'record_button.dart';

class EchoRecordButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onTapWhileDisabled;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressEnd;
  final bool selected;
  final bool recording;
  final int distance;
  final double size;
  final double iconSize;

  const EchoRecordButton({
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
      onTap: onTap,
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      selected: selected,
      size: size,
      recording: recording,
      onTapWhileDisabled: onTapWhileDisabled,
      child: Icon(
        CupertinoIcons.antenna_radiowaves_left_right,
        color: CupertinoColors.white,
        size: iconSize,
      ),
      distance: distance,
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HexColor('FF6BD6'), HexColor('7724FF')]),
    );
  }
}
