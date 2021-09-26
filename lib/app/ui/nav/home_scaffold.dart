import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:humors/app/ui/base/home.dart';
import '../base/category_list.dart';

class HomeScaffold extends StatelessWidget {
  HomeScaffold({
    required this.currentTab,
    required this.onSelectTab,
  });

  String currentTab;
  ValueChanged<String> onSelectTab;

  Map<String, IconData> tabLabels = {
    'home': Icons.home,
    'survey': Icons.list,
    'data': Icons.bar_chart_rounded
  };

  List<Widget> _tabsPages = [
    HomePage(),
    CategoryListPage(),
    Container()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem('home'),
          _buildItem('survey'),
          _buildItem('data'),
        ],
        onTap: (index) => onSelectTab(tabLabels.keys.elementAt(index)),
      ),
      tabBuilder: (BuildContext context, index) {
        return _tabsPages[index];
      },
    );
  }

  BottomNavigationBarItem _buildItem(String tabName) {
    final color = currentTab == tabName ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        tabLabels[tabName],
        color: color,
      ),
      label: tabName,
    );
  }
}
