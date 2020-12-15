

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/ui/screens/app.dart';
import 'package:jitsi_meet_example/ui/screens/homeInstrucaoPaciente.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/findAllDoctors.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/homeview.dart';
import 'package:jitsi_meet_example/ui/screens/loginview.dart';
import 'package:jitsi_meet_example/ui/screens/splashscreen.dart';
import 'ui/screens/homePacienteRegister.dart';

class Router
{
  static Route<dynamic> generateSRoute(RouteSettings settings){

    switch(settings.name)
    {
      case '/':
        return MaterialPageRoute(builder: (_)=>App());

      case 'splash':return MaterialPageRoute(builder:(_)=>SplashScreen());  
   //  case 'splash':return MaterialPageRoute(builder:(_)=>VideoCall()); 
      case 'login':
       return MaterialPageRoute(builder: (_)=>LoginView());
      case 'homeWidget':return MaterialPageRoute(builder: (_)=>HomeView());
      case 'categoryWidget':return MaterialPageRoute(builder: (_)=>FindAllDoctors());
      case 'registerPatient':return MaterialPageRoute(builder: (_)=>HomePacienteRegister());
      case 'instruction':return MaterialPageRoute(builder: (_)=> HomeInstrucaoPaciente());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}