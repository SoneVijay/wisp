import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisp/Child/ChildHome.dart';
import 'package:wisp/Parent/list.dart';

class AddChild extends StatefulWidget {
  @override
  _AddChildState createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference firestore_users = Firestore.instance.collection("user");
  CollectionReference firestore_wisp = Firestore.instance.collection("PET");
  String user_firstName,
      user_lastName,
      user_email,
      _password,
      parent_id,
      wispName,
      childId;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        var firebaseUser = await FirebaseAuth.instance.currentUser();
        Firestore.instance
            .collection('user')
            .document(firebaseUser.uid)
            .get()
            .then((DocumentSnapshot) => parent_id = firebaseUser.uid);
        Firestore.instance
            .collection('user')
            .document(user.uid)
            .get()
            .then((DocumentSnapshot) => childId = user.uid);
      }
    });

  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  void navigateToNextScreen() {
  MaterialPageRoute(builder: (context) => ChildHome());
  }

  addChild() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        AuthResult newUser = await _auth.createUserWithEmailAndPassword(
            email: user_email.trim(), password: _password);
        if (newUser != null) {
          await firestore_users.document(newUser.user.uid).setData({
            "user_email": user_email,
            "user_firstName": user_firstName,
            "user_lastName": user_lastName,
            "user_role": "child",
            "parent_id": parent_id,
            "wisp": wispName
          });
          await firestore_wisp.document(newUser.user.uid).setData({
            "childId": childId,
            "pet_experience": 0,
            "pet_level": 0,
            "pet_type": wispName
          });
          navigateToNextScreen();
        }
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
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

  //navigate
  navigateToNextPage() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => childrenList()));
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
                    text: 'ADD A CHILD',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
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
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter First Name';
                              },
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              onSaved: (input) => user_firstName = input),
                        ),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return "Enter Last Name";
                              },
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              onSaved: (input) => user_lastName = input),
                        ),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Email';
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                              onSaved: (input) => user_email = input),
                        ),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                              onSaved: (input) => _password = input),
                        ),
                        Container(
                          height: 20,
                        ),
                        //List of Wisps
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 150.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              InkWell(

                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10, top: 10),
                                    width: 150.0,
                                    color: Colors.blue.withOpacity(0.5),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/images/wisp_6.png'),
                                        scale: 2,
                                      ),
                                    ))),
                                onTap: (){

                                  wispName = "wisp_6";
                                },
                              ),
                              Container(
                                width: 10.0,
                              ),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10, top: 10),
                                    width: 150.0,
                                    color: Colors.green.withOpacity(0.5),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/images/wisp_2.png'),
                                        scale: 1,
                                      ),
                                    ))),
                                onTap: () {
                                  wispName = "wisp_2";
                                },
                              ),
                              Container(
                                width: 10.0,
                              ),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10, top: 10),
                                    width: 150.0,
                                    color: Colors.lightBlueAccent.withOpacity(0.5),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/images/wisp_1.png'),
                                        scale: 1,
                                      ),
                                    ))),
                                onTap: () {
                                  wispName = "wisp_1";
                                },
                              ),
                              Container(
                                width: 10.0,
                              ),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10, top: 10),
                                    width: 150.0,
                                    color: Colors.yellow.withOpacity(0.5),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/images/wisp_7.png'),
                                        scale: 2,
                                      ),
                                    ))),
                                onTap: () {
                                  wispName = "wisp_7";
                                },
                              ),
                              Container(
                                width: 10.0,
                              ),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10, top: 10),
                                    width: 150.0,
                                    color: Colors.orangeAccent.withOpacity(0.5),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/images/wisp_5.png'),
                                        scale: 2,
                                      ),
                                    ))),
                                onTap: () {
                                  wispName = "wisp_5";
                                },
                              ),
                              Container(
                                width: 10.0,
                              ),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10, top: 10),
                                    width: 150.0,
                                    color: Colors.pinkAccent.withOpacity(0.5),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/images/wisp_4.png'),
                                        scale: 2,
                                      ),
                                    ))),
                                onTap: () {
                                  wispName = "wisp_4";
                                },
                              ),
                              Container(
                                width: 10.0,
                              ),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10, top: 10),
                                    width: 150.0,
                                    color: Colors.deepOrange.withOpacity(0.5),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/images/wisp_3.png'),
                                        scale: 2,
                                      ),
                                    ))),
                                onTap: () {
                                  wispName = "wisp_3";
                                },
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: 20,
                        ),
                        SizedBox(height: 20),

                        RaisedButton(
                            padding: EdgeInsets.only(
                                left: 120, right: 120, bottom: 18, top: 18),
                            onPressed: addChild,
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
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
