import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wisp/Parent/constant.dart';
import 'package:rive/rive.dart';

class ChildHome extends StatefulWidget {
  @override
  _ChildHomeState createState() => _ChildHomeState();
}

class _ChildHomeState extends State<ChildHome> {
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
getTask()async{
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: deviceHeight,
          width: deviceWidth,
          child: !isloggedin
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[
              SizedBox(height: deviceHeight * 0.03),
            Container(
              child: Align( alignment: Alignment.topLeft,
              child: logoutButton((){}),
              ),
            ),
              Container(
                          child: FutureBuilder(
                              future: getTask(),
                              builder: (_, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting ) {
                                  return Center(
                                    child: Text("Loading..."),);
                                } else {
                                  return Container(
                                      child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: deviceHeight * 0.35,
                                              child: RiveAnimation.asset('lib/images/pet_4.riv'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: deviceWidth * 0.1, right: deviceWidth * 0.1, top: deviceHeight * 0.01,bottom: deviceHeight * 0.01,),
                                              child: new LinearPercentIndicator(
                                                width: deviceWidth * 0.80,
                                                lineHeight: deviceHeight * 0.02,
                                                percent: finalExp,
                                                center: Text(
                                                  exp.toString(),
                                                  style: new TextStyle(fontSize: 12.0),
                                                ),
                                                linearStrokeCap: LinearStrokeCap.roundAll,
                                                backgroundColor: Colors.grey,
                                                progressColor: Colors.blue,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(7.0),
                                              child: new Text(
                                                'LEVEL 1',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                                height: deviceHeight * 0.40,
                                                width: deviceWidth * 0.80,
                                                color: Colors.white.withOpacity(0.5),
                                                  child: ListView.builder(
                                                  itemCount:  snapshot.data != null ? snapshot.data.length : 0,
                                                  itemBuilder: (_, index) {
                                                    return Padding(
                                                        padding: EdgeInsets.only(top:0.0),
                                                      child: Dismissible(
                                                      key: Key(UniqueKey().toString()),
                                                      onDismissed: (direction) async {
                                                        deletetask(snapshot.data[index].reference.documentID);
                                                      },
                                                      child: ListTile(
                                                        title:
                                                        Text(snapshot.data[index].data["task_name"]),
                                                        subtitle: Text("${snapshot.data[index].data["task_details"]} ${snapshot.data[index].data["task_experience".toString()]}" + " Exp"),
                                                      ),
                                                      background: Container(
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.only(left: 20.0),
                                                        color: Colors.red,
                                                        child: Icon(
                                                          Icons.delete_forever_sharp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ));
                                                  })),
                                          ]
                                      )
                                  );
                                }
                              }),
                        ),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/child_bg.png'),fit: BoxFit.cover,
              )
          ),
        ));
  }
}

