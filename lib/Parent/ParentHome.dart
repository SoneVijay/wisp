import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'childrenList.dart';
import 'constant.dart';



class ParentHome extends StatefulWidget {
  @override
  _ParentHomeState createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
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
    Navigator.pushReplacementNamed(context, "Home");
  }
  childList() async {
    Navigator.pushReplacementNamed(context, "ChildList");
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Align( alignment: Alignment.topLeft,
                    child: logoutButton((){}),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      childrenButton((){
                        Get.to(childrenScreen());
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/p1.png'),fit: BoxFit.cover,
              )
          ),
        ),
      ),
    );
  }
  Widget logoutButton( Function function){
    return Padding(
      padding: const EdgeInsets.only(top: 25,right: 16),
      child: Row( mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed:signOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('LOGOUT',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
            ),
            style: ElevatedButton.styleFrom(
              primary: primaryColor.withOpacity(0.9),
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
  Widget childrenButton(Function function){
    return GestureDetector( onTap:childList,
      child: Container( margin: EdgeInsets.only(top: 120,right: 25,left: 25),
        height: 57,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(child: Text('CHILDREN',style: TextStyle(fontWeight: FontWeight.w600),)),
      ),
    );
  }

}