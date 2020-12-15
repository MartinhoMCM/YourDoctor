
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';



Map<TabItem, String> tabName = {
  TabItem.home: 'Home',
  TabItem.appointment: 'Apontamento',
  TabItem.person:'Person'
  
};

Map<TabItem, Color> activeTabColor = {
  TabItem.home:  blueColor,
  TabItem.appointment:  blueColor,

  TabItem.person: blueColor,


};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.home),
        _buildItem(tabItem: TabItem.appointment),
    
        _buildItem(tabItem: TabItem.person),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {

    IconData icon = Icons.layers;

    switch(tabItem)
    {
      case TabItem.home:icon = Icons.home;
      break;
      case TabItem.appointment:icon = Icons.calendar_today;
      break;
      case TabItem.person:icon = Icons.person;
      break;

    }

    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(''
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? activeTabColor[item] : Colors.grey;
  }
}
