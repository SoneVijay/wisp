import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Widget/childrenWidget.dart';
import 'constant.dart';
import 'package:wisp/Parent/Model/childrenList.dart';



class childrenList extends StatefulWidget {
  @override
  _childrenListState createState() => _childrenListState();
}

class _childrenListState extends State<childrenList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //ignore: non_constant_identifier_names
  CollectionReference firestore_users = Firestore.instance.collection("user");
  bool isloggedin = true;

  checkAuthentification() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("Home");
      }
    });
  }

  signOut() async {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, "Home");
  }
  Addchild() async {
    Navigator.pushReplacementNamed(context, "AddChild" );
  }
  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded( child: Container(
                child: Align( alignment: Alignment.topLeft,
                  child: logoutButton((){}),
                ),
              )),
              Expanded(flex: 4, child: Container(
                child: myWidget(context),
              )),
            ],
          ),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/p2.png'),fit: BoxFit.cover,
              )
          ),
        ),
      ),
    );
  }
  Widget logoutButton( Function function){
    return Padding(
      padding: const EdgeInsets.only(top: 18,right: 16),
      child: Row( mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed:signOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,),
              child: Text('LOGOUT',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[300],
              onPrimary: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myWidget(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 3,
            physics: BouncingScrollPhysics(),
            itemCount: ChildrenCardsList.list.length,
            itemBuilder: (BuildContext context,int index)=> buildChildrenCardsListCard(context,index),
            staggeredTileBuilder: (index) {
              return new StaggeredTile.count(1, index.isEven ? 1.2: 1.2);
            }
        ),
      ),
    );
  }
  Widget childrenButton(Function function){
    return GestureDetector( onTap:Addchild,
      child: Container( margin: EdgeInsets.only(top: 120,right: 25,left: 25),
        height: 57,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(child: Text('CHILDREN',style: TextStyle(fontWeight: FontWeight.w600),)),
      ),
    );
  }
}