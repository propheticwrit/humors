import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import '../../nav/menu.dart';
import 'package:humors/services/api.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage();

  static Future<void> show({required BuildContext context}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfigurationPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ConfigurationPageState();
}


class _ConfigurationPageState extends State<ConfigurationPage> {

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('No data in categories list'));
  }
}