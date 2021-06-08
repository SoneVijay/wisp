import 'package:wisp/Parent/Model/childrenList.dart';
import 'package:wisp/Parent/AddChild.dart';
import 'package:flutter/material.dart';

Widget buildChildrenCardsListCard(BuildContext context, int index) {
  final data=ChildrenCardsList.list[index];
  return GestureDetector( onTap: (){navigateToNextScreen(context);},
    child:Container(
      height: 150,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(data.imagePath),fit: BoxFit.fill,
          )
      ),
    ),
  );
}

void navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AddChild()));
}