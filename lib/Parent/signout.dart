import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisp/Start.dart';

class signOut extends StatefulWidget {
  @override
  _signOutState createState() => _signOutState();
}

class _signOutState extends State<signOut> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //ignore: non_constant_identifier_names
  CollectionReference firestore_users = Firestore.instance.collection("user");
  bool isloggedin = true;

  checkAuthentification() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("Home");
      }
    });
  }

  signOut() async {
    _auth.signOut();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Start()), (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    signOut();
  }
}
