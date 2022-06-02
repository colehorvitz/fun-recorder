import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_recorder/ui/components/responsive_buttons/responsive_tap_widget.dart';

class Option extends StatefulWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final Color iconColor;
  final String text;
  final bool isDestructive;

  const Option(
      {Key key,
      this.onTap,
      this.iconData,
      this.text,
      this.isDestructive = false,
      this.iconColor = CupertinoColors.black})
      : super(key: key);

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveTapWidget(
        defaultColor: CupertinoColors.white,
        activeColor: CupertinoColors.systemGrey6,
        onTapUp: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.text,
                  style: TextStyle(
                      color: widget.isDestructive
                          ? CupertinoColors.destructiveRed
                          : CupertinoColors.black)),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(widget.iconData,
                      color: widget.isDestructive
                          ? CupertinoColors.destructiveRed
                          : widget.iconColor)),
            ],
          ),
        ));
  }
}
