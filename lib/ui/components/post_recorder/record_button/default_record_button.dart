import 'package:flutter/cupertino.dart';

import '../../../../services/hex_color.dart';
import 'record_button.dart';

class DefaultRecordButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onTapWhileDisabled;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressEnd;
  final bool selected;
  final bool recording;
  final int distance;
  final double size;

  const DefaultRecordButton({
    Key key,
    this.onTap,
    this.selected,
    this.recording,
    this.distance,
    this.onTapWhileDisabled,
    this.onLongPress,
    this.onLongPressEnd,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecordButton(
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      onTap: onTap,
      size: size,
      onTapWhileDisabled: onTapWhileDisabled,
      selected: selected,
      recording: recording,
      distance: distance,
      child: Container(),
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HexColor('FF8A8A'), HexColor('FF0000')]),
    );
  }
}
