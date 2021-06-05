import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wisp/Parent/Model/childrenList.dart';
import 'package:wisp/Parent/Widget/childrenWidget.dart';
import 'package:wisp/Parent/constant.dart';
import 'package:flutter/material.dart';


class childrenScreen extends StatelessWidget {
  const childrenScreen({Key key}) : super(key: key);

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
          ElevatedButton(onPressed:function,
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

}
