import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password, user_role;

  checkAuthentification() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Firestore.instance
            .collection('user')
            .document(user.uid)
            .get()
            .then((snapshot) {
          user_role = snapshot.data['user_role'];
          if (user_role == "parent") {
            Navigator.pushReplacementNamed(context, "ParentMainScreen");
          } else {
            Navigator.pushReplacementNamed(context, "ChildHome");
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email.trim(), password: _password);
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

  navigateToSignUp() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }

  navigateToHome() async {
    Navigator.pushReplacementNamed(context, "Home");
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
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: RaisedButton(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        onPressed: navigateToHome,
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
                  height: 60,
                  child: RichText(
                      text: TextSpan(
                        text: 'Welcome Again!',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      )),
                ),
                Container(
                  height: 300,
                  child: RiveAnimation.asset(
                    'lib/images/wisp_8.riv',
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Email';
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                              onSaved: (input) => _email = input),
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
                        SizedBox(height: 20),
                        RaisedButton(
                            padding: EdgeInsets.only(
                                left: 120, right: 120, bottom: 18, top: 18),
                            onPressed: login,
                            child: Text(
                              'SIGN IN',
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
                Container(
                  height: 20,
                ),
                GestureDetector(
                  child: Text('Create an Account?'),
                  onTap: navigateToSignUp,
                )
              ],
            ),
          ),
        ));
  }
}