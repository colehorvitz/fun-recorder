import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AudioFileUploadRepository {
  const AudioFileUploadRepository();

  Future<File> copyFile(String path) async {
    final dir = await getTemporaryDirectory();
    final fileName =
        "${DateTime.now().microsecondsSinceEpoch}-${basename(path).replaceAll(" ", "-")}";
    return await File(path).copy('${dir.path}/$fileName');
  }
}
