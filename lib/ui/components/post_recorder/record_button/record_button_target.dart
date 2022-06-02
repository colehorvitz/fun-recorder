import 'package:flutter/cupertino.dart';

class RecordButtonTarget extends StatelessWidget {
  final bool recording;

  const RecordButtonTarget({Key key, this.recording}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 150),
      opacity: recording ? 0 : 1,
      curve: Curves.easeInOut,
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 90,
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(recording ? 10 : 90),
              border:
                  Border.all(color: CupertinoColors.systemGrey5, width: 4))),
    );
  }
}
