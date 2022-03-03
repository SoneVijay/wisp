import 'dart:collection';
import 'dart:math';
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
  CollectionReference firestore_task = Firestore.instance.collection("TASK");
  CollectionReference firestore_pet = Firestore.instance.collection("PET");
  bool isloggedin = true;
  String firstName = "", wisp = "", user_id;
  int petExp, max = 100;
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

  getTask() async {
    FirebaseUser user = await _auth.currentUser();
    user_id = user.uid;
    Firestore.instance
        .collection('user')
        .document(user.uid)
        .get()
        .then((snapshot) {
      wisp = snapshot.data['wisp'].toString();
    });
    Firestore.instance
        .collection('PET')
        .document(user_id)
        .get()
        .then((snapshot) {
      petExp = snapshot.data['pet_experience'];
    });
    finalExp = petExp / 100;
    print("exp:" + finalExp.toString());
    print("user id:" + user_id);
    print("user wisp:" + wisp);
    print("pet_experience:" + petExp.toString());

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('TASK')
        .where('child_id', isEqualTo: user_id)
        .getDocuments();
    return qn.documents;
  }

  Widget logoutButton(Function function) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: signOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
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

  Future sortData() async {}
  Future deletetask(String taskId) async {
    try {
      await Firestore.instance.collection('TASK').document(taskId).delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
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
                child: Align(
                  alignment: Alignment.topLeft,
                  child: logoutButton(() {}),
                ),
              ),
              Container(
                child: FutureBuilder(
                    future: getTask(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading..."),
                        );
                      } else {
                        return Container(
                            child: Column(children: <Widget>[
                              SizedBox(
                                height: deviceHeight * 0.35,
                                child: RiveAnimation.asset(
                                    'lib/images/' + wisp + '.riv'),
                              ),
                              //streambuilder
                              Padding(
                                padding: EdgeInsets.only(
                                  left: deviceWidth * 0.1,
                                  right: deviceWidth * 0.1,
                                  top: deviceHeight * 0.01,
                                  bottom: deviceHeight * 0.01,
                                ),
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
                              //another streambuilder
                              Container(
                                  height: deviceHeight * 0.40,
                                  width: deviceWidth * 0.80,
                                  child: StreamBuilder(
                                      stream: firestore_task.snapshots(),
                                      builder: (context, snapshot){
                                        if(snapshot.hasError){
                                          return Text("Error");
                                        }
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return Text("Loading ...");
                                        }
                                        if(snapshot.hasData){
                                          return Container(
                                              height: deviceHeight * 0.40,
                                              width: deviceWidth * 0.80,
                                              child: ListView.builder(
                                                  itemCount:snapshot.data.documents.length,
                                                  itemBuilder: (_, index) {
                                                    _buildPopupDialog(BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Alert!'),
                                                        content: new Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(
                                                                "Are you sure that you're done with your task?"),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          new FlatButton(
                                                            onPressed: () {
                                                              deletetask(snapshot.data[index]
                                                                  .reference.documentID);
                                                              Navigator.of(context).pop();
                                                            },
                                                            textColor: Color(0xFF03164d),
                                                            child: const Text('Yes'),
                                                          ),
                                                          new FlatButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            textColor: Color(0xFF0000Ff),
                                                            child: const Text('No'),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Padding(
                                                      padding: EdgeInsets.only(top: 0.0),
                                                      child: Card(
                                                        child: ListTile(
                                                          title: Text(snapshot
                                                              .data.documents[index].data["task_name"]),
                                                          subtitle: Text(
                                                              "${snapshot.data.documents[index].data["task_details"]} ${snapshot.data.documents[index].data["task_experience".toString()]}" +
                                                                  " Exp"),
                                                          trailing: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              RaisedButton(
                                                                child: Text(
                                                                  'Done',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                                color: Color(0xFF03164d),
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext
                                                                    context) =>
                                                                        _buildPopupDialog(
                                                                            context),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                    //return Text("${snapshot.data.documents[index].data['task_name']}");
                                                  }));
                                        }
                                        return Text("Loading....");
                                      }
                                  )),
                            ]));
                      }
                    }),
              ),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/child_bg.png'),
                fit: BoxFit.cover,
              )),
        ));
  }
}
