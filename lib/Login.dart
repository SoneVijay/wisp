import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<  FormState>();

  String _email, _password, user_role;

  checkAuthentification() async {
    print('function initialized');
    _auth.onAuthStateChanged.listen((user) {
      print('authStateChanged...');
      if (user != null) {
        print(user);
        // please remove this, kay wala ka sang route nga may "/" ang ngalan
        // ang ngalan sang routes sa app mo ang Home, Login, Sign up, ParentHome, ChildHome, AddChild
        // wala sang "/"

        // Navigator.pushReplacementNamed(context, "/");
        // amo ni ang sakto nga paghandle sang then() kay async function na ang pagkuha sang data
        // the then() will trigger after nga makuha sang app ang data
        Firestore.instance.collection('user').document(user.uid).get().then((snapshot) {
          user_role = snapshot.data['user_role'];
          print('user role ' +user_role);
          if(user_role == "parent"){
            Navigator.pushReplacementNamed(context, "ParentHome");
          }
          else{
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

        // 1: Nag doble imo nga pag check sang authentication
        // stick ka na lang sa checkAuthentication function
        // as that will automatically trigger once may changes sa authentication
        // logged in/out

        // 2: sala imo pag declare sang then(); dapat isulod mo dira ang pagnavigate
        // sa next page, kay inside the then statement dira mo maaccess ang user data from firestore

        // dont use this, transferred on the checkAuth function
        // var firebaseUser = await FirebaseAuth.instance.currentUser();
        // Firestore.instance.collection('user').document(firebaseUser.uid).get().then((DocumentSnapshot) =>
        //     user_role = DocumentSnapshot.data['user_role']);
        // print(firebaseUser.uid);
        // print('user role ' +user_role);
        // if(user_role == "parent"){
        //   Navigator.pushReplacementNamed(context, "ParentHome");
        // }
        // else{
        //   Navigator.pushReplacementNamed(context, "ChildHome");
        // }

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
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
                      )),),

                Container(
                  height: 300,
                  child: Image(
                    image: AssetImage("lib/images/WhiteWisp.png"),
                    fit: BoxFit.contain,
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
                            padding: EdgeInsets.only(left: 120, right: 120,bottom: 18,top: 18),
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