import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/simple_boolean_cubit/simple_boolean_cubit.dart';

class ResponsiveTapIcon extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Color defaultColor;
  final double size;
  final Color activeColor;
  final IconData iconData;
  final EdgeInsets padding;

  const ResponsiveTapIcon(
      {Key key,
      this.onTap,
      this.onLongPress,
      this.defaultColor,
      this.activeColor,
      this.iconData,
      this.size,
      this.padding})
      : super(key: key);

  @override
  _ResponsiveTapIconState createState() => _ResponsiveTapIconState();
}

class _ResponsiveTapIconState extends State<ResponsiveTapIcon> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleBooleanCubit>(
      create: (context) => SimpleBooleanCubit(false),
      child: BlocBuilder<SimpleBooleanCubit, bool>(builder: (context, pressed) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) {
            context.read<SimpleBooleanCubit>().setTrue();
          },
          onTapUp: (d) => this.setState(() {
            context.read<SimpleBooleanCubit>().setFalse();
          }),
          onTapCancel: () => this.setState(() {
            context.read<SimpleBooleanCubit>().setFalse();
          }),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Container(
            padding: widget.padding,
            child: Icon(
              widget.iconData,
              color: widget.onTap == null
                  ? widget.defaultColor.withOpacity(.5)
                  : pressed
                      ? widget.activeColor
                      : widget.defaultColor,
              size: widget.size,
            ),
          ),
        );
      }),
    );
  }
}
