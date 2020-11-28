

import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/ui/screens/profile/profileview.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigatorProfile extends StatelessWidget
{
  TabNavigatorProfile({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  //Missing code here
  void _push(BuildContext context, {int materialIndex:500})
  {

  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {int materialIndex: 500})
  {
    return {
      TabNavigatorRoutes.root:(context)=>ProfileView(),
      TabNavigatorRoutes.detail: (context) => Container(
        child: Center(
          child: Text('Appointment', style: TextStyle(color: Colors.green),),
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings)
      {
        return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context));
      },
    );
  }


}
