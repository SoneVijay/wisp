import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}
class _AddTaskState extends State<AddTask> {
  var selectedChild, user_id;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference firestore_users = Firestore.instance.collection("user");
  CollectionReference firestore_task = Firestore.instance.collection("TASK");
  String taskName, taskExp, childId, taskDetails;
  DateTime _date = DateTime.now();

  addTask() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        if((childId != null || taskName != null) || (taskDetails != null || taskExp != null)) {
          _buildPopupDialog();
          await firestore_task.document().setData({
            "child_id": childId,
            "task_name": taskName,
            "task_details": taskDetails,
            "task_date": _date,
            "task_experience": taskExp,
          });

        }
      }
      catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

   _buildPopupDialog() {
    return new AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Task Added!"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
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
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                ),
                Container(
                  height: 60,
                ),
                Container(
                  height: 50,
                  child: RichText(
                      text: TextSpan(
                        text: 'Create New Task',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      )),
                ),

                Container(
                  height: 30,
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FutureBuilder(
                            future: getChild(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Text("Loading..."),
                                );
                              } else {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  height: 125.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:  snapshot.data != null ? snapshot.data.length : 0,
                                    itemBuilder: (_, index) {
                                      return InkWell(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                            width: 125.0,
                                            color: _selectedIndex != null && _selectedIndex == index
                                                ? Colors.blue.withOpacity(0.5)
                                                : Colors.white,
                                              child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 50, right: 50, top: 80),
                                                      decoration: new BoxDecoration(
                                                        image: new DecorationImage(
                                                          image: ExactAssetImage("lib/images/" + snapshot.data[index].data["wisp"] + '.png'),
                                                          scale: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                  snapshot.data[index].data["user_firstName"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black),
                                                ),

                                              ]),
                                          ),
                                        onTap: (){
                                          childId = (snapshot.data[index].documentID);
                                          print(childId);
                                          _onSelected(index);
                                        },
                                      );
                                    }),
                              );
                              }
                            }),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return '         Enter Task Name';
                              },
                              decoration: InputDecoration(
                                labelText: 'Task Name',
                                prefixIcon: Icon(Icons.addchart_outlined),
                              ),
                              onSaved: (input) => taskName = input),
                        ),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return '         Enter Task Description';
                              },
                              decoration: InputDecoration(
                                labelText: 'Task Description',
                                prefixIcon: Icon(Icons.addchart_outlined),
                              ),
                              onSaved: (input) => taskDetails = input),
                        ),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return '         Enter Experience';
                              },
                              decoration: InputDecoration(
                                labelText: 'Experience',
                                prefixIcon: Icon(Icons.addchart_outlined),
                              ),
                              onSaved: (input) => taskExp = input),
                        ),

                        Container(
                          height: 20,
                        ),
                        Container(
                          height: 20,
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                            padding: EdgeInsets.only(
                                left: 120, right: 120, bottom: 18, top: 18),
                            onPressed: (){
                              addTask();
                            },
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            color: Color(0xFF8E97FD)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}