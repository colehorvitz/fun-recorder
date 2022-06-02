import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/blocs/audio_file_upload_bloc/file_upload_event.dart';
import 'package:fun_recorder/blocs/audio_file_upload_bloc/file_upload_state.dart';

import '../../data/audio_file_upload_repository.dart';

class AudioFileUploadBloc
    extends Bloc<AudioFileUploadEvent, AudioFileUploadState> {
  final AudioFileUploadRepository repo;

  AudioFileUploadBloc(this.repo) : super(AudioFileUploadInitial()) {
    on<AudioFileUploaded>(_onAudioFileUploaded);
    on<AudioFileErrorDismissed>(_onAudioFileErrorDismissed);
  }

  void _onAudioFileUploaded(
      AudioFileUploaded event, Emitter<AudioFileUploadState> emit) async {
    final file = await repo.copyFile(event.filePath);
    emit(AudioFileUploadSuccess(file));
  }

  void _onAudioFileErrorDismissed(
      AudioFileErrorDismissed event, Emitter<AudioFileUploadState> emit) {
    emit(AudioFileUploadInitial());
  }
}
