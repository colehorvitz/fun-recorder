import 'package:flutter/cupertino.dart';
import 'package:fun_recorder/ui/utils.dart';

class PostRecorderTimer extends StatelessWidget {
  final Duration duration;

  const PostRecorderTimer({Key key, this.duration}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(prettyFormatDuration(duration));
  }
}
