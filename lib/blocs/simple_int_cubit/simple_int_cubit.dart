import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleIntCubit extends Cubit<int> {
  SimpleIntCubit(int ininitialInt) : super(ininitialInt);

  void setInt(int i) {
    emit(i);
  }

  void increment() {
    emit(state + 1);
  }

  void decrement() {
    emit(state - 1);
  }
}
