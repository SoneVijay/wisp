// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../Start.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({Key key}) : super(key: key);

  @override
  _CreditScreenState createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  signOut() async {
    _auth.signOut();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Start()), (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(828, 1792),
        orientation: Orientation.portrait);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/CreditScreenBG.png'),
              fit: BoxFit.cover,
            )),
        width: 828.w,
        height: 1792.h,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: 200.h,
              left: 190.w,
              child: SvgPicture.asset(
                'lib/images/logo.svg',
                height: 650.h,
              ),
            ),
            Positioned(
              top: 900.h,
              left: 250.w,
              child: Text(
                "WISP",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: const Color(0xff000000),
                  fontSize: 141.4024200439453.sp,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 28.280484008789063.sp,
                ),
              ),
            ),
            Positioned(
              top: 1040.h,
              left: 310.w,
              child: Text(
                "An Assitive Tehnology",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: const Color(0xff000000),
                  fontSize: 33.sp,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Positioned(
              top: 1200.h,
              left: 320.w,
              child: InkWell(
                onTap: () {
                  //Signout Functionality
                  signOut();
                },
                child: Container(
                  width: 272.06396484375.w,
                  height: 76.6190185546875.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff28324e),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      "SIGN OUT",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: const Color(0xffffffff),
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -120.w,
              top: 400.h,
              child: SvgPicture.asset(
                'lib/images/bg-texture.svg',
                height: 1500.h,
                width: 500.w,
              ),
            ),
            Positioned(
              top: 1600.h,
              left: 220.w,
              child: Text(
                "© 2021, Fritz Bryan Angulo, Kristara Mendoza\nAmiel John Macahilo, Vijay Tangub",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: const Color(0xff000000),
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
