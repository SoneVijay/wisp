import 'package:flutter/material.dart';

class parentNotification extends StatefulWidget {
  @override
  _parentNotificationState createState() => _parentNotificationState();
}

class _parentNotificationState extends State<parentNotification> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: new Container(
          child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("NOTIFICATION PAGE"),
                ],
              )),
        ),
      ),
    );
  }
}
