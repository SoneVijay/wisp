import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Start.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference firestore_users = Firestore.instance.collection("user");
  String user_firstName, user_lastName, user_email, _password;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "ParentHome");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        AuthResult user = await _auth.createUserWithEmailAndPassword(
            email: user_email.trim(), password: _password);
        if (user != null) {
          await firestore_users.document(user.user.uid).setData({"user_email": user_email, "user_firstName": user_firstName,"user_lastName": user_lastName, "user_role": "parent"});

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
          context, MaterialPageRoute(builder: (context) => Start()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
              Container(
              height: 50,),
                Container(
              height: 60,
                  padding: EdgeInsets.only(left:10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: RaisedButton(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        onPressed:  navigateToNextPage,
                        child: RichText(
                            text: TextSpan(
                              text: 'BACK',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.50),
                        ),
                        color: Color(0xFFEBEAEC)),
                ),
              ),
            Container(
              height: 50,
              child: RichText(
                  text: TextSpan(
                    text: 'Join Us!',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  )),),

            Container(
              height: 250,
              child: Image(
                image: AssetImage("lib/images/3WhiteWisp.png"),
                fit: BoxFit.contain,
              ),
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
                        ),Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Last Name';
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
                        SizedBox(height: 20),
                        RaisedButton(
                            padding: EdgeInsets.only(left: 120, right: 120,bottom: 18,top: 18),
                            onPressed: signUp,
                            child: Text(
                              'SIGN UP',
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