import 'package:flutter/material.dart';
import 'package:wisp/Child/ChildHome.dart';
import 'package:wisp/Parent/ParentHome.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'Start.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      theme: ThemeData(
          primaryColor:  Color(0xFF8E97FD)
      ),
      debugShowCheckedModeBanner: false,

      initialRoute: 'Home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        'Home': (context) => Start(),
        'Login': (context) => Login(),
        'SignUp': (context) => SignUp(),
        'ParentHome': (context) => ParentHome(),
        'ChildHome': (context) => ChildHome(),
        'AddChild': (context) => ParentHome(),

      },

    );
  }

}