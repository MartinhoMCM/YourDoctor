import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/models/consulta.dart';
import 'package:jitsi_meet_example/ui/screens/appointment/appointmentview.dart';
import 'package:jitsi_meet_example/ui/screens/chat/messageuser.dart';
import 'package:jitsi_meet_example/widgtes/tab_navigator_home.dart';

class TabNavigatorProfileRoutes {
  static const String root = '/';
  static const String chat= 'chat';
  static const String video='/video';
}

class TabNavigatorAppointment extends StatelessWidget
{
  TabNavigatorAppointment({this.navigatorKey, this.tabItem, this.pkPatient});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final int pkPatient;
  Consulta consulta;

  //Missing code here
  void _push(BuildContext context, {int materialIndex:500})
  {
      
      var routeBuilders =_routeBuilders(context, materialIndex: materialIndex);
 print('material index $materialIndex');
 if(materialIndex==1){
   print('dentro');
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[TabNavigatorProfileRoutes.chat](context)));
    }
    else{
               Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[TabNavigatorProfileRoutes.root](context)));
    }
     

  }


  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {int materialIndex: 500})
  {
   print('aqui');
   //print('consulta ${consulta.nomeDoctor}');
    return {
      TabNavigatorProfileRoutes.root:(context)=>AppointmentView(pkPatient:pkPatient,
      onConsulta:(value)=> consulta=value,
      onPush: (materialIndex)=>_push(context, 
      materialIndex: materialIndex),),
      TabNavigatorProfileRoutes.chat: (context) => MessageUser(
        onPush:(materialIndex)=> _push(context,materialIndex: materialIndex),
        consulta: consulta,
        
      )
   
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorProfileRoutes.root,
      onGenerateRoute: (routeSettings)
      {
        return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context));
      },
    );
  }


}