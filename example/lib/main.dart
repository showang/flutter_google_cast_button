import 'package:flutter/material.dart';
import 'package:flutter_google_cast_button/bloc_media_route.dart';
import 'package:flutter_google_cast_button/cast_button_widget.dart';
import 'package:flutter_google_cast_button/flutter_google_cast_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MediaRouteBloc mediaRouteBloc;

  @override
  void initState() {
    super.initState();
    mediaRouteBloc = MediaRouteBloc();
  }

  @override
  void dispose() {
    mediaRouteBloc.close();
    mediaRouteBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: kToolbarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CastButtonWidget(
                  bloc: mediaRouteBloc,
                  tintColor: Colors.deepPurple,
                ),
                RaisedButton(
                  child: Text("Show cast dialog manually"),
                  onPressed: () => FlutterGoogleCastButton.showCastDialog(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
