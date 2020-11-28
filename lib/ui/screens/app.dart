
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/widgtes/bottom_navigation.dart';
import 'package:jitsi_meet_example/widgtes/tab_navigator_appointment.dart';
import 'package:jitsi_meet_example/widgtes/tab_navigator_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgtes/tab_navigator_home.dart';

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  GlobalKey appStateKey =new GlobalKey();



  //final navigatorKey = GlobalKey<NavigatorState>();
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.appointment: GlobalKey<NavigatorState>(),
    TabItem.chat: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.person: GlobalKey<NavigatorState>(),
  };

  TabItem currentTab = TabItem.home;
  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
   var pkPatient =Provider.of<Patient>(context).pkPaciente;
    return WillPopScope(
      onWillPop: ()async =>!await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            buildOffstageNavigatorUI(TabItem.home,
                TabNavigatorHome(tabItem: TabItem.home,navigatorKey: navigatorKeys[TabItem.home], mContext: context,)),
            buildOffstageNavigatorUI(TabItem.appointment,
                TabNavigatorAppointment(tabItem: TabItem.appointment,navigatorKey: navigatorKeys[TabItem.appointment], pkPatient:pkPatient)),
           buildOffstageNavigatorUI(TabItem.person,
                TabNavigatorProfile(tabItem: TabItem.person,navigatorKey:navigatorKeys[TabItem.person],)),
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }


  Widget buildOffstageNavigatorUI(TabItem tabItem, Widget widget) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: widget,
    );
  }
 

}
