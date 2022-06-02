import 'package:flutter/cupertino.dart';

class Selections extends StatefulWidget {
  final List<Widget> selections;
  final String title;

  const Selections({Key key, this.selections, this.title}) : super(key: key);

  @override
  _SelectionsState createState() => _SelectionsState();
}

class _SelectionsState extends State<Selections> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(color: CupertinoColors.white),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: CupertinoColors.systemGrey6))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            ...widget.selections,
            SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    borderRadius: BorderRadius.all(Radius.circular(64)),
                    onPressed: Navigator.of(context).pop,
                    child: Text("Cancel"),
                  ),
                ),
              )
            ]),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
