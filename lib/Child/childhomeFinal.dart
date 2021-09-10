import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wisp/Parent/constant.dart';
import 'package:rive/rive.dart';

class ChildHomeFinal extends StatefulWidget {
  @override
  _ChildHomeState createState() => _ChildHomeState();
}

class _ChildHomeState extends State<ChildHomeFinal> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //ignore: non_constant_identifier_names
  CollectionReference firestore_users = Firestore.instance.collection("user");
  bool isloggedin = true;
  String firstName = "", wisp = "", user_id;
  int exp, max=100;
  double finalExp;

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

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }
  Future getTask()async{
    FirebaseUser user = await _auth.currentUser();
    user_id = user.uid;
    Firestore.instance
        .collection('user')
        .document(user.uid)
        .get()
        .then((snapshot) {
      wisp = snapshot.data['wisp'].toString();});
    Firestore.instance
        .collection('PET')
        .document(user_id)
        .get()
        .then((snapshot) {
      exp = snapshot.data['pet_experience'];});
    finalExp = exp/100;
    print("exp:" + finalExp.toString());
    print("user id:" + user_id);
    print("user wisp:" + wisp);
    print("pet_experience:" + exp.toString());

    var firestore = Firestore.instance;
    QuerySnapshot qn =
    await firestore.collection('TASK').where('child_id', isEqualTo: user_id).getDocuments();
    return qn.documents;
  }

  Future deletetask(String taskId) async {
    try {
      return await Firestore.instance
          .collection('task')
          .document(taskId)
          .delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Widget logoutButton( Function function){
    return Padding(
      padding: const EdgeInsets.only(top: 18,right: 16),
      child: Row( mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed:signOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,),
              child: Text('LOGOUT',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/child_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 48.0,
            left: 10.0,
            right: 10.0,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "New York",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

