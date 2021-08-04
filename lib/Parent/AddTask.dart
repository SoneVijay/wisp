import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference firestore_users = Firestore.instance.collection("user");
  CollectionReference firestore_task = Firestore.instance.collection("TASK");
  String taskName, taskExp, childId, taskDetails, user_id;
  DateTime _date = DateTime.now();

  addTask() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await firestore_task.document().setData({
        "child_id": childId,
        "task_name": taskName,
        "task_details": taskDetails,
        "task_date": _date,
        "task_experience": taskExp,
      });
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
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

  Future getChild() async {
    FirebaseUser user = await _auth.currentUser();
    user_id = user.uid;
    var firestore = Firestore.instance;
    QuerySnapshot qn =
    await firestore.collection('user').where('parent_id', isEqualTo: user_id).getDocuments();
    return qn.documents;
  }


  List _fruits = ["Choose a Child","Apple", "Banana", "Pineapple", "Mango", "Grapes"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedFruit;

  @override
  void initState() {
  _dropDownMenuItems = buildAndGetDropDownMenuItems(_fruits);
  _selectedFruit = _dropDownMenuItems[0].value;
  super.initState();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List fruits) {
  List<DropdownMenuItem<String>> items = new List();
  for (String fruit in fruits) {
  items.add(new DropdownMenuItem(value: fruit, child: new Text(fruit)));
  }
  return items;
  }

  void changedDropDownItem(String selectedFruit) {
  setState(() {
  _selectedFruit = selectedFruit;
  });
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
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DropdownButton(
                                value: _selectedFruit,
                                items: _dropDownMenuItems,
                                onChanged: changedDropDownItem,
                              )
                            ],
                          ),
                        ),

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
                              if((taskDetails != null && taskName != null) && (taskExp!= null && childId != null)){
                                addTask();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => _buildPopupDialog(context),
                                );
                              }
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
