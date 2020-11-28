
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/presentation/my_flutter_app_icons.dart';
import 'package:jitsi_meet_example/presentation/my_flutter_app_icons1.dart';
import 'package:jitsi_meet_example/presentation/my_flutter_app_icons2.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';


class UserDataCard extends StatefulWidget{
  final String title;
  final int index;

  UserDataCard({this.title, this.index});

  @override
  State<StatefulWidget> createState() {

    return UserDataCardState();
  }
  
}



class UserDataCardState extends State<UserDataCard>{

  String topic="...";
  Icon icon;

  @override
  void initState() {

    if(widget.index==0){
      topic ="Minha altura atual";
    }
    else if(widget.index==1){
      topic ="Peso do corpo";
    }
    else if(widget.index==2){
      topic ="Grupo Sanguíneo";
    }
    setIcon(widget.index);

    super.initState();
  }

  void setIcon(index){

    if(index==0){
      icon =Icon(MyFlutterApp.altura, color: whiteColor, size: 25.0,);
    }
    else if(index==1){
      icon =Icon(MyFlutterApp1.peso, color: whiteColor, size: 25.0,);
    }
    else if(index==2){
      icon =Icon(MyFlutterApp2.sangue, color: whiteColor, size: 25.0,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.0,
      height: 220.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 8.0
              ),
              child: Container(
                width: 160.0,
                height: 190.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [secondPrimaryColor, middleColor],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 8),
                      blurRadius: 8
                    )
                  ],
                  borderRadius: BorderRadius.circular(5.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UIHelper.verticalSpaceMedium(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child:icon
                    ),
                    UIHelper.verticalSpaceMedium(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('${topic}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: whiteColor),),
                    ),
                   
                    UIHelper.verticalSpaceLarge(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('${widget.title}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: whiteColor),),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}