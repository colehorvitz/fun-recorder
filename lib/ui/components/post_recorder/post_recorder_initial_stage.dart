import 'package:flutter/cupertino.dart';

class PostRecorderInitialStage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 36.0, right: 36, bottom: 72),
        child: Text(
          "Press the button to start recording".toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: CupertinoColors.systemGrey2,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
