import 'package:flutter/material.dart';
import 'package:humors/app/nav/home_scaffold.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  String _currentTab = 'home';

  void _select(String tabName) {
    setState(() => _currentTab = tabName);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select
    );
  }
}
