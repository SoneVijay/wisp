import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class childList extends StatefulWidget {
  @override
  _childListState createState() => _childListState();
}

class _childListState extends State<childList> {
  Future getChild() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
        await firestore.collection("user").getDocuments(); //get all documents
        return qn.documents; //returns all documents
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getChild(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(
                          snapshot.data[index].data["user_firstName"] ?? ''),
                    );
                  });
            }
          }),
    );
  }
}
