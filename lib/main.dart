
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jitsi_meet_example/locator.dart';
import 'package:jitsi_meet_example/routes.dart';
import 'package:jitsi_meet_example/service/authentication_service.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/paciente.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MainApp createState() => MainApp();
}

class MainApp extends State<MyApp> {
  // This widget is the root of your application.
  SharedPreferences prefs; 

  void addToSF() async{
     prefs = await SharedPreferences.getInstance();
     prefs.setInt('intValue', 1);
  }
  @override
  void initState() {
       
    locator.reset();
    addToSF();
    setupLocator();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      initialData: Patient.initial(),
      create: (context)=>locator<AuthenticationService>().userController.stream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: solidWhiteColor,
        title: 'Our Doctor',
        theme: ThemeData(
            primaryColor: primaryColor),
         initialRoute: 'splash',
        onGenerateRoute: Router.generateSRoute,
      ),
    );
  }

}


