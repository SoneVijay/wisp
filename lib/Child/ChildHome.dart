import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String firstName = "", wisp = "",user_id;

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
    print("user id:" + user_id);
    print("user wisp:" + wisp);
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
        body: Container(
          child: !isloggedin
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[
              SizedBox(height: 20.0),
            Container(
              child: Align( alignment: Alignment.topLeft,
              child: logoutButton((){}),
              ),
            ),
              SizedBox(
                height: 350,
                child: RiveAnimation.asset('lib/images/wisp_6.riv'),
              ),
              Container(
                  height: 420.0,
                  width: 350.0,
                  color: Colors.white.withOpacity(0.5),
                  child: Column(
                      children: <Widget>[
                        Container(
                          height:415.0,
                          child: FutureBuilder(
                              future: getTask(),
                              builder: (_, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: Text("Loading..."),);
                                } else {
                                  return ListView.builder(

                                      itemCount:  snapshot.data != null ? snapshot.data.length : 0,
                                      itemBuilder: (_, index) {
                                        return Dismissible(
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
                                        );
                                      });
                                }
                              }),
                        ),
                      ]
                  ),
               ),
            ],
          ),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/child_bg.png'),fit: BoxFit.cover,
              )
          ),
        ));
  }
}

