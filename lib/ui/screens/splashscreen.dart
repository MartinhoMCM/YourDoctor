import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/screens/homeInstrucaoPaciente.dart';
import 'package:jitsi_meet_example/ui/screens/loginview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart' as splash;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   SharedPreferences prefs ;

addIntToSF() async {
   prefs = await SharedPreferences.getInstance();
   prefs.setInt('intValue', 123);
}

getIntValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int intValue = prefs.getInt('intValue');
  return intValue;
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        splash.SplashScreen(
          seconds: 5,
          navigateAfterSeconds: new HomeInstrucaoPaciente(),
          loaderColor: blueColor,
          backgroundColor: whiteColor,
          styleTextUnderTheLoader: normalStyleBlue,
          photoSize: 100.0,   
          
          image: Image(image: AssetImage("assets/ourdoctor.png")),
          loadingText: Text('O médico em sua casa', style: normalStyleBlue,),
        ),
       
      ],
    ));
  }
}

/**
 * 
 *   Container(
           color: whiteColor,
         ),
         Positioned(
           top: 50.0,
           left: 8.0,
           right: 8.0,
           height: 250.0,
           child:Container(
             decoration: BoxDecoration(
               image: DecorationImage(image: AssetImage('assets/logo.jpeg'))
             ),
           ),
           ),
           Positioned(
             left: 8.0,
             right: 8.0,
             bottom: 16.0,
             //width: 100.0,
             height: 50.0,
             child: Center(
               child: Container(
                 width: 50.0,
                 height: 50.0,
                 child: CircularProgressIndicator(
                   backgroundColor: primaryColor,
                   strokeWidth: 4.0,
                 ),
               ),
             ),
             ),
             Positioned(child: Text(''))
     
 */
