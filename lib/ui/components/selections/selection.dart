import 'package:flutter/cupertino.dart';

import '../responsive_buttons/responsive_tap_widget.dart';

class Selection extends StatefulWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData iconData;
  final IconData selectedIconData;
  final EdgeInsets padding;

  const Selection(
      {Key key,
      this.title,
      this.isSelected,
      this.onTap,
      this.iconData,
      this.selectedIconData,
      this.description = '',
      this.padding = const EdgeInsets.all(12.0)})
      : super(key: key);

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveTapWidget(
        defaultColor: CupertinoColors.white,
        activeColor: CupertinoColors.systemGrey6,
        onTapUp: widget.onTap,
        child: Container(
          padding: widget.padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: widget.isSelected
                          ? Icon(widget.selectedIconData ?? widget.iconData,
                              color: CupertinoColors.activeBlue)
                          : Icon(widget.iconData, color: CupertinoColors.black),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                                color: widget.isSelected
                                    ? CupertinoColors.activeBlue
                                    : CupertinoColors.black),
                          ),
                          SizedBox(
                            height: widget.description.isNotEmpty ? 4 : 0,
                          ),
                          if (widget.description.isNotEmpty)
                            Text(
                              widget.description,
                              maxLines: 2,
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 15,
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4),
              widget.isSelected
                  ? Icon(CupertinoIcons.checkmark,
                      color: CupertinoColors.activeBlue)
                  : Container()
            ],
          ),
        ));
  }
}
