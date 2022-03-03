import 'package:flutter/material.dart';
import 'package:wisp/Child/childhome.dart';
import 'package:wisp/Parent/list.dart';
import 'package:wisp/Parent/AddChild.dart';
import 'package:wisp/Parent/ParentMainScreen.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'Start.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configOneSignel();
  runApp(MyApp());
}

void configOneSignel()
{
  OneSignal.shared.init('4a0cf1fb-90f2-45ca-ac75-b9ace100f337');
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xFF8E97FD)),
      debugShowCheckedModeBanner: false,
      initialRoute: 'Home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        'Home': (context) => Start(),
        'Login': (context) => Login(),
        'SignUp': (context) => SignUp(),
        'ParentHome': (context) => ParentMainScreen(),
        'ChildHome': (context) => ChildHome(),
        'ChildList': (context) => childrenList(),
        'AddChild': (context) => AddChild(),
        'ParentMainScreen': (context) => ParentMainScreen(),
      },
    );
  }
}
