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
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("4a0cf1fb-90f2-45ca-ac75-b9ace100f337");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
    // Will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });

  runApp(MyApp());
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
