import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/simple_boolean_cubit/simple_boolean_cubit.dart';

class ResponsiveTapWidget extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onTapCancel;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final Color defaultColor;
  final Color activeColor;
  final Widget child;
  final BoxShape shape;
  final BorderRadius borderRadius;
  final Border border;
  final HitTestBehavior behavior;

  const ResponsiveTapWidget(
      {Key key,
      this.onTap,
      this.onLongPress,
      this.defaultColor,
      this.activeColor,
      this.child,
      this.onTapCancel,
      this.onTapUp,
      this.onTapDown,
      this.shape = BoxShape.rectangle,
      this.borderRadius = BorderRadius.zero,
      this.border,
      this.behavior = HitTestBehavior.opaque})
      : super(key: key);

  @override
  _ResponsiveTapWidgetState createState() => _ResponsiveTapWidgetState();
}

class _ResponsiveTapWidgetState extends State<ResponsiveTapWidget> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleBooleanCubit>(
      create: (context) => SimpleBooleanCubit(false),
      child: BlocBuilder<SimpleBooleanCubit, bool>(builder: (context, pressed) {
        return Container(
          decoration: BoxDecoration(
            shape: widget.shape,
            color: pressed ? widget.activeColor : widget.defaultColor,
            border: widget.border,
            borderRadius:
                widget.shape == BoxShape.rectangle ? widget.borderRadius : null,
          ),
          child: GestureDetector(
            behavior: widget.behavior,
            onTapDown: (d) {
              context.read<SimpleBooleanCubit>().setTrue();
              if (widget.onTapDown != null) {
                widget.onTapDown();
              }
            },
            onTapUp: (d) {
              context.read<SimpleBooleanCubit>().setFalse();
              if (widget.onTapUp != null) {
                widget.onTapUp();
              }
            },
            onTapCancel: () {
              context.read<SimpleBooleanCubit>().setFalse();
              if (widget.onTapCancel != null) {
                widget.onTapUp();
              }
            },
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: widget.child,
          ),
        );
      }),
    );
  }
}
