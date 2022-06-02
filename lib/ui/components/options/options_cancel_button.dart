import 'package:flutter/cupertino.dart';

class OptionsCancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: CupertinoButton(
              color: CupertinoColors.activeBlue,
              padding: EdgeInsets.symmetric(vertical: 16),
              borderRadius: BorderRadius.all(Radius.circular(64)),
              onPressed: Navigator.of(context).pop,
              child: Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
