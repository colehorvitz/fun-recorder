import 'package:flutter/cupertino.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../../../services/hex_color.dart';
import 'record_button.dart';

class HighPitchRecordButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onTapWhileDisabled;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressEnd;
  final bool selected;
  final bool recording;
  final int distance;
  final double size;
  final double iconSize;

  const HighPitchRecordButton({
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
      size: size,
      selected: selected,
      recording: recording,
      onTapWhileDisabled: onTapWhileDisabled,
      child: Icon(
        MaterialCommunityIcons.waveform,
        color: CupertinoColors.white,
        size: iconSize,
      ),
      distance: distance,
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HexColor('A3FF0E'), HexColor('00B0FB')]),
    );
  }
}
