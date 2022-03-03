import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rive/rive.dart';
import 'package:wisp/Start.dart';
import 'package:wisp/Widget/bezierContainer.dart';

import 'constant.dart';

class signOut extends StatefulWidget {
  @override
  _signOutState createState() => _signOutState();
}

class _signOutState extends State<signOut> {
  String userId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //ignore: non_constant_identifier_names
  bool isloggedin = true;
  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    fetchUserInfo();
  }
  fetchUserInfo() async{
    FirebaseUser getUser = await FirebaseAuth.instance.currentUser();
    userId = getUser.uid;
  }
  checkAuthentification() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("Home");
      }
    });
  }
  Widget logoutButton(Function function) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, right: 85),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: signOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Text(
                'LOGOUT',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[300],
              onPrimary: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
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
  Future getUserInfo() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
    await firestore.collection('user').getDocuments();
    return qn.documents;
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    getUserInfo();
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .1),
                      Container(
                        height: height * .06,
                        child: RichText(
                            text: TextSpan(
                              text: 'WISP',
                              style: TextStyle(
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )),
                      ),
                      Container(
                        height: height * .06,
                        child: RichText(
                            text: TextSpan(
                              text: 'An Assitive Technology',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )),
                      ),
                      Container(
                        height: 60,),
                      Container(
                        alignment: Alignment.center,
                        height: height * .25,
                        child: RiveAnimation.asset(
                          'lib/images/WhiteWisp.riv',
                        ),
                      ),
                      SizedBox(height: height * .02),
                      logoutButton((){}),
                      SizedBox(height: height * .14),
                      Container(
                        alignment: Alignment.center,
                        height: height * .25,
                        child: Text(
                          "© 2021, Fritz Bryan Angulo, Kristara Mendoza\nAmiel John Macahilo, Vijay Tangub",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: const Color(0xff000000),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: height * .1),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
