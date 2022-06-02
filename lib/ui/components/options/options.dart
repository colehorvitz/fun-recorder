import 'package:flutter/cupertino.dart';

import 'options_cancel_button.dart';

class Options extends StatefulWidget {
  final Widget header;
  final List<Widget> options;

  const Options({Key key, this.header, this.options}) : super(key: key);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntrinsicHeight(
        child: Column(
          children: [
            SizedBox(height: 12),
            widget.header ?? SizedBox.shrink(),
            ...widget.options,
            SizedBox(height: 24),
            OptionsCancelButton(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
