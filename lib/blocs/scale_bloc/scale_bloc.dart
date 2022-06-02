import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScaleBloc extends Bloc<ScaleEvent, ScaleState> {
  ScaleBloc(this.initialScale) : super(ScaleState(initialScale, initialScale)) {
    on<ScaleFactorChanged>(_onScaleFactorChanged);
    on<ScaleBaseFactorChanged>(_onScaleBaseFactorChanged);
  }

  final double initialScale;

  void _onScaleFactorChanged(
      ScaleFactorChanged event, Emitter<ScaleState> emit) {
    emit(state.copyWith(scaleFactor: event.factor));
  }

  void _onScaleBaseFactorChanged(
      ScaleBaseFactorChanged event, Emitter<ScaleState> emit) {
    emit(state.copyWith(baseFactor: event.factor));
  }
}

abstract class ScaleEvent {
  const ScaleEvent();
}

class ScaleFactorChanged extends ScaleEvent {
  final double factor;

  const ScaleFactorChanged(this.factor);
}

class ScaleBaseFactorChanged extends ScaleEvent {
  final double factor;

  const ScaleBaseFactorChanged(this.factor);
}

class ScaleState extends Equatable {
  final scaleFactor;
  final baseFactor;

  const ScaleState(this.scaleFactor, this.baseFactor);

  ScaleState copyWith({double scaleFactor, double baseFactor}) {
    return ScaleState(
        scaleFactor ?? this.scaleFactor, baseFactor ?? this.baseFactor);
  }

  @override
  List<Object> get props => [scaleFactor, baseFactor];
}
