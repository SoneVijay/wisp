import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'childList.dart';

class childrenList extends StatefulWidget {
  @override
  _childrenListState createState() => _childrenListState();
}

class _childrenListState extends State<childrenList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String user_id, task_userId;
/*
  FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging();

    messaging.getToken().then((value) {
      print(value);
    });

    messaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        }
    );
  }
*/
  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      Firestore.instance
          .collection('user')
          .document(user.uid)
          .get();
      if (user != null) {
        user_id = user.uid.toString();
      }
      else{
        Navigator.of(context).pushReplacementNamed("Home");
      }
    });
  }


  Future getChild() async {
    FirebaseUser user = await _auth.currentUser();
    user_id = user.uid;
    var firestore = Firestore.instance;
    QuerySnapshot qn =
    await firestore.collection('user').where('parent_id', isEqualTo: user_id).getDocuments();
    return qn.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getChild(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return ListView.builder(
                  itemCount:  snapshot.data != null ? snapshot.data.length : 0,
                  itemBuilder: (_, index) {
                    return ListTile(
                        leading: Image(
                          image: AssetImage("lib/images/" + snapshot.data[index].data["wisp"] + '.png'),
                          fit: BoxFit.contain,
                        ),
                        title:
                        Text(snapshot.data[index].data["user_firstName"]),
                        subtitle: Text("${snapshot.data[index].data["user_email"]}"),
                    );
                  });
            }
          }),
    );
  }
}
