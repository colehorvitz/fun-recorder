import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_recorder/ui/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      title: 'Fun Recorder',
      theme: CupertinoThemeData(
          barBackgroundColor: CupertinoColors.white,
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
              primaryColor: CupertinoColors.black,
              navTitleTextStyle: TextStyle(
                  fontFamily: "LibreFranklin",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.black),
              textStyle: TextStyle(
                  fontFamily: "LibreFranklin",
                  fontSize: 16,
                  color: CupertinoColors.black))),
      home: Home(),
    );
  }
}
