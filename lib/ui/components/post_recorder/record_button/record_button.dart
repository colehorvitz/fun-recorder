import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/blocs/simple_boolean_cubit/simple_boolean_cubit.dart';

class RecordButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressEnd;
  final VoidCallback onTapWhileDisabled;
  final Widget child;
  final bool selected;
  final bool recording;
  final Gradient gradient;
  final int distance;
  final double size;

  const RecordButton(
      {Key key,
      this.onTap,
      this.child,
      this.gradient,
      this.selected,
      this.recording,
      this.onTapWhileDisabled,
      this.distance,
      this.onLongPress,
      this.onLongPressEnd,
      this.size = 72})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BlocProvider<SimpleBooleanCubit>(
          create: (_) => SimpleBooleanCubit(false),
          child: BlocBuilder<SimpleBooleanCubit, bool>(
              builder: (context, pressed) {
            return GestureDetector(
              onLongPress: recording || !selected ? null : onLongPress,
              onLongPressEnd:
                  !selected || !recording ? null : (_) => onLongPressEnd(),
              behavior: HitTestBehavior.translucent,
              onTapDown: !selected
                  ? null
                  : (_) => context.read<SimpleBooleanCubit>().setTrue(),
              onTapCancel: !selected
                  ? null
                  : () => context.read<SimpleBooleanCubit>().setFalse(),
              onTapUp: recording && !selected
                  ? null
                  : !selected
                      ? (_) => onTapWhileDisabled()
                      : (_) {
                          onTap();
                          context.read<SimpleBooleanCubit>().setFalse();
                        },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                opacity: recording && !selected
                    ? 0
                    : pressed
                        ? 0.45
                        : 1,
                child: Container(
                  width: size,
                  height: size,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: child,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(
                          recording && selected ? 10 : 72),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
