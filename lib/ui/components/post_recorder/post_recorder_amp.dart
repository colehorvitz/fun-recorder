import 'package:flutter/cupertino.dart';

class PostRecorderAmp extends StatelessWidget {
  final Color color;
  final double amp;

  const PostRecorderAmp({Key key, this.color, this.amp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200 * amp,
      width: 4,
      margin: EdgeInsets.only(right: 1.5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
    );
  }
}
