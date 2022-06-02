import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleDoubleCubit extends Cubit<double> {
  SimpleDoubleCubit(double initialState) : super(initialState);

  void setDouble(double d) => emit(d);
}
