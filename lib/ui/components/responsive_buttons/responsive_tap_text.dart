import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/simple_boolean_cubit/simple_boolean_cubit.dart';

class ResponsiveTapText extends StatelessWidget {
  final String text;
  final TextStyle defaultStyle;
  final TextStyle pressedStyle;
  final EdgeInsets padding;
  final VoidCallback onTap;
  final TextAlign align;
  final TextOverflow overflow;

  const ResponsiveTapText(this.text,
      {Key key,
      this.defaultStyle,
      this.pressedStyle,
      this.padding = EdgeInsets.zero,
      this.onTap,
      this.align = TextAlign.start,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleBooleanCubit>(
      create: (context) => SimpleBooleanCubit(false),
      child: BlocBuilder<SimpleBooleanCubit, bool>(builder: (context, pressed) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: onTap == null
              ? null
              : (d) {
                  context.read<SimpleBooleanCubit>().setTrue();
                },
          onTapCancel: onTap == null
              ? null
              : () {
                  context.read<SimpleBooleanCubit>().setFalse();
                },
          onTapUp: onTap == null
              ? null
              : (d) {
                  context.read<SimpleBooleanCubit>().setFalse();
                  onTap();
                },
          child: Padding(
            padding: padding,
            child: Text(
              text,
              textAlign: align,
              overflow: overflow,
              style: pressed || onTap == null ? pressedStyle : defaultStyle,
            ),
          ),
        );
      }),
    );
  }
}
