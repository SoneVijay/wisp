import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';


class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToSignUp() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }

  Widget pet (Function function){
    return Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'lib/images/WhiteWisp.riv',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
            SizedBox(
              height:50,),
            SizedBox(
              height:400,
              child: pet((){}),
            ),
        SizedBox(
          height:50,),
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