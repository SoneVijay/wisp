import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToSignUp() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/images/BgIndex.png"),
          fit: BoxFit.contain,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(
                  text: ' W I S P',
                  style: TextStyle(
                      fontSize: 75.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            SizedBox(height: 5),
            RichText(
                text: TextSpan(
                  text: 'An Anti-Lazy Application',
                  style: TextStyle(
                    fontFamily: "Roboto",
                      fontSize: 20.0,
                      color: Colors.black),
                )),
            SizedBox(height: 20.0),
            SizedBox(height: 35.0),
            Container(
              height: 280,
              child: Image(
                image: AssetImage("lib/images/white.png"),
                fit: BoxFit.contain,
              ),
            ),


            SizedBox(height: 100.0),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.only(left: 120, right: 120,bottom: 18,top: 18),
                    onPressed: navigateToLogin,
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
            SizedBox(height:20.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                GestureDetector(
                  child: Text('Create an Account?'),
                  onTap: navigateToSignUp,
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}