import 'package:flutter/material.dart';
import 'package:wisp/Parent/AddChild.dart';
import 'package:wisp/Parent/list.dart';
import 'package:wisp/Parent/CreditScreen.dart';
import 'package:wisp/Parent/signout.dart';
import 'AddTask.dart';

class ParentMainScreen extends StatefulWidget {
  @override
  _ParentMainScreenState createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  int pageIndex = 0;
  List<Widget> pageList = <Widget>[
    childrenList(),
    AddChild(),
    AddTask(),
    signOut(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageList[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
              if (value == 3) {}
            });
            ;
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Child"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Task"),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
          ],
        ));
  }
}
