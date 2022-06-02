import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBooleanCubit extends Cubit<bool> {
  SimpleBooleanCubit(this.initial) : super(initial);
  final bool initial;

  void setFalse() => emit(false);
  void setTrue() => emit(true);
  void toggle() => emit(!state);
  void setBool(bool value) => emit(value);
}
